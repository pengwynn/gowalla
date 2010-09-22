require 'helper'

class ClientTest < Test::Unit::TestCase

  context "When using the Gowalla API" do
    setup do
      @client = gowalla_test_client
    end


  end

  context "when using basic auth" do
    should "configure api_key, username, and password for easy access" do

      Gowalla.configure do |config|
        config.api_key = 'api_key'
        config.api_secret = nil
        config.username = 'username'
        config.password = 'password'
      end

      @client = Gowalla::Client.new

      stub_get('http://username:password@api.gowalla.com/trips', 'trips.json')
      trips = @client.trips

      @client.username.should == 'username'
    end

    should "configure test mode" do
      Gowalla.configure do |config|
        config.api_key = 'api_key'
        config.api_secret = nil
        config.username = 'username'
        config.password = 'password'
        config.test_mode = true
      end

      Gowalla.test_mode?.should == true

    end
  end

  context "when using OAuth2" do

    setup do
      Gowalla.configure do |config|
        config.api_key = 'api_key'
        config.api_secret = 'api_secret'
      end

      @client = Gowalla::Client.new
    end

    should "confiure api_key, api_secret" do
      @client.api_secret.should == 'api_secret'
      @client.oauth_client.id.should == 'api_key'
    end

    should "create an OAuth2 client" do
      @client.oauth_client.class.to_s.should == "OAuth2::Client"
    end

    should "indicate if it needs an access_token" do
      @client.needs_access?.should == true
    end

  end


end
