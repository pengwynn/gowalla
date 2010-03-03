require 'rubygems'

gem 'hashie', '>= 0.1.3'
require 'hashie'

gem 'httparty', '>= 0.5.0'
require 'httparty'

directory = File.expand_path(File.dirname(__FILE__))

Hash.send :include, Hashie::HashExtensions

module Gowalla
  
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
  def self.configure
    yield self
    true
  end

  class << self
    attr_accessor :api_key
    attr_accessor :username
    attr_accessor :password
  end
  
end

require File.join(directory, 'gowalla', 'client')
