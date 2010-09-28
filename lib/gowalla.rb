require 'hashie'
require 'faraday'
require 'multi_json'
require 'oauth2'
require 'faraday_middleware'

directory = File.expand_path(File.dirname(__FILE__))

Hash.send :include, Hashie::HashExtensions

module Gowalla

  class << self
    attr_accessor :api_key
    attr_accessor :username
    attr_accessor :password
    attr_accessor :api_secret
    attr_accessor :test_mode

    # config/initializers/gowalla.rb (for instance)
    #
    # Gowalla.configure do |config|
    #   config.api_key = 'api_key'
    #   config.username = 'username'
    #   config.password = 'password'
    # end
    #
    # elsewhere
    #
    # client = Gowalla::Client.new
    def configure
      yield self
      true
    end

    def test_mode?
      !!self.test_mode
    end
  end

  require 'gowalla/spots'
  require 'gowalla/items'
  require 'gowalla/trips'
  require 'gowalla/checkins'
  require 'gowalla/flags'
  require 'gowalla/users'
  require 'gowalla/client'

end
