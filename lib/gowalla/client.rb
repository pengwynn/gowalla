require 'forwardable'

module Gowalla
  class Client
    extend Forwardable
    
    attr_reader :username, :api_key, :api_secret
    
    def_delegators :oauth_client, :web_server, :authorize_url, :access_token_url
    
    def initialize(options={})
      @api_key = options[:api_key] || Gowalla.api_key
      @api_secret = options[:api_secret] || Gowalla.api_secret
      @username = options[:username] || Gowalla.username
      @access_token = options[:access_token]
      password = options[:password] || Gowalla.password
      connection.basic_auth(@username, password) unless @api_secret
    end
    
    def user(user_id=nil)
      user_id ||= username
      handle_response(connection.get("/users/#{user_id}"))
    end

    def item(id)
      handle_response(connection.get("/items/#{id}"))
    end

    def stamps(user_id=self.username, limit=20)
      response = connection.get do |req|
        req.url "/users/#{user_id}/stamps", :limit => limit
      end
      handle_response(response).stamps
    end

    def top_spots(user_id=self.username)
      handle_response(connection.get("/users/#{user_id}/top_spots")).top_spots
    end

    def trip(trip_id)
      handle_response(connection.get("/trips/#{trip_id}"))
    end
    
    def spot(spot_id)
      handle_response(connection.get("/spots/#{spot_id}"))
    end
    
    def spot_events(spot_id)
      handle_response(connection.get("/spots/#{spot_id}/events")).activity
    end
    
    def spot_items(spot_id)
      handle_response(connection.get("/spots/#{spot_id}/items")).items
    end
    
    def list_spots(options={})
      query = format_geo_options(options)
      response = connection.get do |req|
        req.url "/spots", query
      end
      handle_response(response).spots
    end
    

    def trips(options={})
      if user_id = options.delete(:user_id)
        options[:user_url] = "/users/#{user_id}"
      end
      query = format_geo_options(options)
      response = connection.get do |req|
        req.url "/trips", query
      end
      handle_response(response).trips
    end

    def categories
      handle_response(connection.get("/categories")).spot_categories
    end
    
    def category(id)
      handle_response(connection.get("/categories/#{id}"))
    end
    
    def needs_access?
      @api_secret and @access_token.to_s == ''
    end
    
    def connection
      
      if api_secret
        @connection ||= OAuth2::AccessToken.new(oauth_client, @access_token)
      else
        headers = default_headers
        headers['X-Gowalla-API-Key'] = api_key if api_key
        @connection ||= Faraday::Connection.new \
          :url => "http://api.gowalla.com", 
          :headers => headers
      end
    end
    
    def oauth_client
      if @oauth_client
        @oauth_client
      else
        conn ||= Faraday::Connection.new \
          :url => "https://api.gowalla.com", 
          :headers => default_headers

        oauth= OAuth2::Client.new(api_key, api_secret, oauth_options = {
          :site => 'https://api.gowalla.com',
          :authorize_url => 'https://gowalla.com/api/oauth/new',
          :access_token_url => 'https://gowalla.com/api/oauth/token'
        })
        oauth.connection = conn
        oauth
      end
    end

    private
    
      def format_geo_options(options={})
        options[:lat] = "+#{options[:lat]}" if options[:lat].to_i > 0
        options[:lng] = "+#{options[:lng]}" if options[:lng].to_i > 0
        if options[:sw] && options[:ne]
          options[:order] ||= "checkins_count desc"
        end
        options
      end
      
      def default_headers
        headers = {
          :accept =>  'application/json', 
          :user_agent => 'Ruby gem'
        }
      end
    
      def handle_response(response)
        case response.status
        when 200
          body = response.respond_to?(:body) ? response.body : response
          data = MultiJson.decode(body)
          if data.is_a?(Hash)
            Hashie::Mash.new(data)
          else
            if data.first.is_a?(Hash)
              data.map{|item| Hashie::Mash.new(item)}
            else
              data
            end
          end
        end
      end
      
    
  end
  
end