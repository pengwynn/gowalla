require 'rubygems'

gem 'hashie', '>= 0.1.3'
require 'hashie'

gem 'httparty', '>= 0.5.0'
require 'httparty'

directory = File.expand_path(File.dirname(__FILE__))

Hash.send :include, Hashie::HashExtensions

module Gowalla
  
  def self.user(user_id)
    Gowalla::Client.new.user(user_id)
  end
  
  def self.events(user_id)
    Gowalla::Client.new.events(user_id)
  end
  
  def self.trip(trip_id)
    Gowalla::Client.new.trip(trip_id)
  end
  
  def self.spot(spot_id)
    Gowalla::Client.new.spot(spot_id)
  end
  
  def self.spot_events(spot_id)
    Gowalla::Client.new.spot_events(spot_id)
  end
  
end

require File.join(directory, 'gowalla', 'client')
