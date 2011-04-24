require 'forwardable'

module Gowalla
  class Client
    extend Forwardable

    include Spots
    include Users
    include Items
    include Trips
    include Checkins
    include Flags

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
      params = {}
      params[:access_token] = @access_token if @access_token
      @connection ||= Faraday.new(:url => api_url, :params => params, :headers => default_headers) do |builder|
        builder.adapter Faraday.default_adapter
        builder.use Faraday::Response::Mashify
        builder.use Faraday::Response::ParseJson
      end

    end

    # Provides the URL for accessing the API
    #
    # @return [String]
    def api_url
      authentication_credentials_provided? ? "https://api.gowalla.com" : "http://api.gowalla.com"
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
      def authentication_credentials_provided?
        @api_key || @api_secret || @username || @access_token
      end

  end

end
