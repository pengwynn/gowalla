require 'helper'

class ClientTest < Test::Unit::TestCase

  context "When using the Gowalla API" do
    setup do
      @client = gowalla_test_client
    end

    context "and working with Items" do
      should "retrieve information about a specific item" do
        stub_get('http://pengwynn:0U812@api.gowalla.com/items/607583', 'item.json')
        item = @client.item(607583)
        item.issue_number.should == 13998
        item.name.should == 'Sweets'
        item.determiner.should == 'some'
      end
    end

    context "and working with Trips" do
      should "retrieve a list of trips" do
        stub_get('http://pengwynn:0U812@api.gowalla.com/trips', 'trips.json')
        trips = @client.trips
        trips.first.name.should == 'London Pub Crawl'
        trips.first.spots.first.url.should == '/spots/164009'
      end

      should "retrieve information about a specific trip" do
        stub_get('http://pengwynn:0U812@api.gowalla.com/trips/1', 'trip.json')
        trip = @client.trip(1)
        trip.creator.last_name.should == 'Gowalla'
        trip.map_bounds.east.should == -63.457031
      end
    end

    context "and working with Flags" do
      should "retrieve a list of flags" do
        stub_get("http://pengwynn:0U812@api.gowalla.com/flags", "flags.json")
        flags = @client.list_flags
        flags.first.spot.name.should == 'Wild Gowallaby #1'
        flags.first.user.url.should == '/users/340897'
        flags.first[:type].should == 'invalid'
        flags.first.status.should == 'open'
      end

      should "retrieve information about a specific flag" do
        stub_get("http://pengwynn:0U812@api.gowalla.com/flags/1", "flag.json")
        flag = @client.flag(1)
        flag.spot.name.should == 'Wild Gowallaby #1'
        flag.user.url.should == '/users/340897'
        flag[:type].should == 'invalid'
        flag.status.should == 'open'
      end
    end

    context "and working with checkins" do
      should "fetch info for a checkin" do
        stub_get("http://pengwynn:0U812@api.gowalla.com/checkins/88", "checkin.json")
        checkin = @client.checkin_info(88)
        checkin.spot.name.should == 'Movie Tavern'
        checkin.message.should == 'There sending us Back-- to the Future!'
      end
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
