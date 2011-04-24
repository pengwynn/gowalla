require 'helper'

class ClientTest < Test::Unit::TestCase

  context "When using the Gowalla API" do
    setup do
      @client = gowalla_test_client
    end
  end

  context "when accessing the API anonymously" do
    should "send requests unencrypted over plain HTTP" do
      @client = Gowalla::Client.new
      @client.api_url.should == 'http://api.gowalla.com'
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
      @client.username.should == 'username'
    end

    should "use HTTPS to avoid sending password in plain text" do
      Gowalla.configure do |config|
        config.api_key = 'api_key'
        config.username = 'username'
        config.password = 'password'
      end

      @client = Gowalla::Client.new
      @client.api_url.should == 'https://api.gowalla.com'
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

    should "use HTTPS to avoid sending credentials in plain text" do
      @client.api_url.should == 'https://api.gowalla.com'
    end

    should "create an OAuth2 client" do
      @client.oauth_client.class.to_s.should == "OAuth2::Client"
    end

    should "indicate if it needs an access_token" do
      @client.needs_access?.should == true
    end

  end

end
