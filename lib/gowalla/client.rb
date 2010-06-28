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
      connection.token_auth(@access_token) if @access_token
    end
    
    # Retrieve information about a specific user
    #
    # @param [String] user_id (authenticated basic auth user) User ID (screen name)
    # @return [Hashie::Mash] User info
    def user(user_id=nil)
      user_id ||= username
      handle_response(connection.get("/users/#{user_id}"))
    end

    # Retrieve information about a specific item
    #
    # @param [Integer] id Item ID
    # @return [Hashie::Mash] item info
    def item(id)
      handle_response(connection.get("/items/#{id}"))
    end

    # Retrieve a list of the stamps the user has collected
    #
    # @param [String] user_id (authenticated basic auth user) User ID (screen name)
    # @param [Integer] limit (20) limit per page
    # @return [Hashie::Mash] stamps info
    def stamps(user_id=self.username, limit=20)
      response = connection.get do |req|
        req.url "/users/#{user_id}/stamps", :limit => limit
      end
      handle_response(response).stamps
    end

    # Retrieve a list of spots the user has visited most often
    #
    # @param [String] user_id (authenticated basic auth user) User ID (screen name)
    # @return [Hashie::Mash] item info
    def top_spots(user_id=self.username)
      handle_response(connection.get("/users/#{user_id}/top_spots")).top_spots
    end

    # Retrieve information about a specific trip
    #
    # @param [Integer] trip_id Trip ID
    # @return [Hashie::Mash] trip info
    def trip(trip_id)
      handle_response(connection.get("/trips/#{trip_id}"))
    end
    
    # Retrieve information about a specific spot
    #
    # @param [Integer] spot_id Spot ID
    # @return [Hashie::Mash] Spot info
    def spot(spot_id)
      handle_response(connection.get("/spots/#{spot_id}"))
    end
    
    # Retrieve a list of check-ins at a particular spot. Shows only the activity that is visible to a given user.
    #
    # @param [Integer] spot_id Spot ID
    # @return [Hashie::Mash] Spot info
    def spot_events(spot_id)
      handle_response(connection.get("/spots/#{spot_id}/events")).activity
    end
    
    # Retrieve a list of items available at a particular spot
    #
    # @param [Integer] spot_id Spot ID
    # @return [Hashie::Mash] Spot info
    def spot_items(spot_id)
      handle_response(connection.get("/spots/#{spot_id}/items")).items
    end
    
    # Retrieve a list of spots within a specified distance of a location
    #
    # @option options [Float] :latitude Latitude of search location
    # @option options [Float] :longitude Longitude of search location
    # @option options [Integer] :radius Search radius (in meters)
    # @return [Hashie::Mash] spots info
    def list_spots(options={})
      query = format_geo_options(options)
      response = connection.get do |req|
        req.url "/spots", query
      end
      handle_response(response).spots
    end
    
    # List of trips
    #
    # @return [<Hashie::Mash>] trip info
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

    # Lists all spot categories
    #
    # @return [<Hashie::Mash>] category info
    def categories
      handle_response(connection.get("/categories")).spot_categories
    end
    
    # Retrieve information about a specific category
    #
    # @param [Integer] id Category ID
    # @return [Hashie::Mash] category info
    def category(id)
      handle_response(connection.get("/categories/#{id}"))
    end
    
    # Check for missing access token
    #
    # @return [Boolean] whether or not to redirect to get an access token
    def needs_access?
      @api_secret and @access_token.to_s == ''
    end
    
    # Raw HTTP connection, either Faraday::Connection 
    #
    # @return [Faraday::Connection]
    def connection
      url = @access_token ? "https://api.gowalla.com" : "http://api.gowalla.com"
      params = {}
      params[:access_token] = @access_token if @access_token
      @connection ||= Faraday::Connection.new(:url => url, :params => params, :headers => default_headers) do |builder|
        builder.adapter Faraday.default_adapter
        builder.use Faraday::Response::MultiJson
        builder.use Faraday::Response::Mashify
      end
            
    end
    
    # Provides raw access to the OAuth2 Client
    #
    # @return [OAuth2::Client] 
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
    
      # @private
      def format_geo_options(options={})
        options[:lat] = "+#{options[:lat]}" if options[:lat].to_i > 0
        options[:lng] = "+#{options[:lng]}" if options[:lng].to_i > 0
        if options[:sw] && options[:ne]
          options[:order] ||= "checkins_count desc"
        end
        options
      end
      
      # @private
      def default_headers
        headers = {
          :accept =>  'application/json', 
          :user_agent => 'Ruby gem',
          'X-Gowalla-API-Key' => api_key
        }
      end
      
      # @private
      def handle_response(response)
        case response.status
        when 200
          response.body
        end
      end
      
    
  end
  
end