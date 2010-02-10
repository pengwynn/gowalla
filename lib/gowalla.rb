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
      
    Gowalla.api_key = api_key
    Gowalla.username = username
    Gowalla.password = password
    true
  end
  
  def self.api_key
    @api_key
  end
  
  def self.api_key=(value)
    @api_key = value
  end
  
  def self.username
    @username
  end
  
  def self.username=(value)
    @username = value
  end
  
  def self.password
    @password
  end
  
  def self.password=(value)
    @password = value
  end
  
  
end

require File.join(directory, 'gowalla', 'client')
