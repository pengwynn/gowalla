require 'helper'

class GowallaTest < Test::Unit::TestCase

  context "When using the Gowalla API" do
    setup do
      @client = Gowalla::Client.new(:username => 'pengwynn', :password => '0U812', :api_key => 'gowallawallabingbang')
    end

    context "and working with Spots" do
      should "Retrieve a list of spots within a specified distance of a location" do
        stub_get("http://pengwynn:0U812@api.gowalla.com/spots?lat=%2B33.237593417&lng=-96.960559033&radius=50", "spots.json")
        spots = @client.list_spots(:lat => 33.237593417, :lng => -96.960559033, :radius => 50)
        spots.first.name.should == 'Gnomb Bar'
        spots.first.radius_meters.should == 50
      end

      should "Retrieve a list of spots within a specified bounds" do
        stub_get("http://pengwynn:0U812@api.gowalla.com/spots?sw=%2839.25565142103586%2C%20-8.717308044433594%29&nw=%2839.31411296530539%2C%20-8.490715026855469%29", "spots.json")
        spots = @client.list_spots(:sw => "(39.25565142103586, -8.717308044433594)", :nw => "(39.31411296530539, -8.490715026855469)")
        spots.first.name.should == 'Gnomb Bar'
      end

      should "Retrieve information about a specific spot" do
        stub_get('http://pengwynn:0U812@api.gowalla.com/spots/18568', 'spot.json')
        spot = @client.spot(18568)
        spot.name.should == "Wahoo's"
        spot.twitter_username.should == 'Wahoos512'
        spot.spot_categories.first.name.should == 'Mexican'
      end

      should "retrieve a list of check-ins at a particular spot. Shows only the activity that is visible to a given user" do
        stub_get('http://pengwynn:0U812@api.gowalla.com/spots/452593/events', 'events.json')
        events = @client.spot_events(452593)
        events.first[:type].should == 'checkin'
        events.first.user.last_name.should == 'Mack'
      end

      should "retrieve a list of items available at a particular spot" do
        stub_get('http://pengwynn:0U812@api.gowalla.com/spots/18568/items', 'items.json')
        items = @client.spot_items(18568)
        items.first.issue_number.should == 27868
        items.first.name.should == 'Bowl of Noodles'
      end

      should "lists all spot categories" do
        stub_get("http://pengwynn:0U812@api.gowalla.com/categories", "categories.json")
        categories = @client.categories
        categories.size.should == 9
        categories.first.name.should == 'Architecture & Buildings'
        categories.first.description.should == 'Bridge, Corporate, Home, Church, etc.'
        categories.first.spot_categories.size.should == 15
        categories.first.spot_categories.first.name.should == 'Bridge'
      end

      should "retrieve information about a specific category" do
        stub_get("http://pengwynn:0U812@api.gowalla.com/categories/1", "category.json")
        category = @client.category(1)
        category.name.should == 'Coffee Shop'
      end

      should "retrieve flags associated with that spot" do
        stub_get("http://pengwynn:0U812@api.gowalla.com/spots/1/flags", "flags.json")
        flags = @client.spot_flags(1)
        flags.first.spot.name.should == 'Wild Gowallaby #1'
        flags.first.user.url.should == '/users/340897'
        flags.first[:type].should == 'invalid'
        flags.first.status.should == 'open'
      end
    end

    context "and working with Users" do

      should "retrive information about the current user if no user specified" do
        stub_get('http://pengwynn:0U812@api.gowalla.com/users/pengwynn', 'user.json')
        user = @client.user
        user.bio.should == "CTO & co-founder of Gowalla. Ruby/Cocoa/JavaScript developer. Game designer. Author. Indoorsman."
        user.stamps_count.should == 506
      end

      should "retrieve information about a specific user" do
        stub_get('http://pengwynn:0U812@api.gowalla.com/users/sco', 'user.json')
        user = @client.user('sco')
        user.bio.should == "CTO & co-founder of Gowalla. Ruby/Cocoa/JavaScript developer. Game designer. Author. Indoorsman."
        user.stamps_count.should == 506
      end

      should "retrieve a list of the stamps the user has collected" do
        stub_get('http://pengwynn:0U812@api.gowalla.com/users/1707/stamps?limit=20', 'stamps.json')
        stamps = @client.stamps(1707)
        stamps.size.should == 20
        stamps.first.spot.name.should == "Muck-N-Dave's Texas BBQ"
        stamps.first.spot.address.locality.should == 'Austin'
      end

      should "retrieve a list of spots the user has visited most often" do
        stub_get('http://pengwynn:0U812@api.gowalla.com/users/1707/top_spots', 'top_spots.json')
        top_spots = @client.top_spots(1707)
        top_spots.size.should == 10
        top_spots.first.name.should == 'Juan Pelota Cafe'
        top_spots.first.user_checkins_count.should == 30
      end

      should "retrieve a list of spot urls the user has visited" do
        stub_get('http://pengwynn:0U812@api.gowalla.com/users/sco/visited_spots_urls', 'spots_urls.json')
        spot_urls = @client.visited_spots_urls('sco')
        spot_urls.size.should == 22
        spot_urls.first.should == '/spots/682460'
      end

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
