require 'faraday'
require 'oauth2'
require 'faraday_middleware'

directory = File.expand_path(File.dirname(__FILE__))

module Gowalla

  class << self
    attr_accessor :api_key
    attr_accessor :username
    attr_accessor :password
    attr_accessor :api_secret
    attr_accessor :test_mode

    # Configures default credentials easily
    # @yield [api_key, username, password]
    def configure
      yield self
      true
    end

    def test_mode?
      !!test_mode
    end
  end

  require 'gowalla/client'

end
