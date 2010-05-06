require 'helper'

class TestGowalla < Test::Unit::TestCase

  context "When using the documented Gowalla API" do
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
        stub_get("http://pengwynn:0U812@api.gowalla.com/spots?sw=(39.25565142103586%2C%20-8.717308044433594)&nw=(39.31411296530539%2C%20-8.490715026855469)", "spots.json")
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
    end
    
    context "and working with Users" do
      
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
    
  end
  
  context "When using the UNDOCUMENTED Gowalla API" do
    setup do
      @client = Gowalla::Client.new(:username => 'pengwynn', :password => '0U812', :api_key => 'gowallawallabingbang')
    end
    
    
    should "retrieve details for the current user" do
      stub_get('http://pengwynn:0U812@api.gowalla.com/users/pengwynn', 'me.json')
      user = @client.user
      user.can_post_to_twitter?.should == true
      user.can_post_to_facebook?.should == true
      user.bio.should == "Web designer and Ruby developer."
      user.stamps_count.should == 15
    end
    
    should "retrieve details for a user" do
      stub_get('http://pengwynn:0U812@api.gowalla.com/users/1707', 'me.json')
      user = @client.user(1707)
      user.can_post_to_twitter?.should == true
      user.can_post_to_facebook?.should == true
      user.bio.should == "Web designer and Ruby developer."
      user.stamps_count.should == 15
    end
    
    should "retrieve events for a user" do
      stub_get('http://pengwynn:0U812@api.gowalla.com/users/1707/events', 'events.json')
      events = @client.events(1707)
      events.first[:type].should == 'checkin'
      events.first.user.last_name.should == 'Mack'
    end
    
    should "retrieve events for a user's friends" do
      stub_get('http://pengwynn:0U812@api.gowalla.com/visits/recent', 'events.json')
      events = @client.friends_events
      events.first[:type].should == 'checkin'
      events.first.user.last_name.should == 'Mack'
    end
    
    should "retrieve friend requests for a user" do
      stub_get('http://pengwynn:0U812@api.gowalla.com/users/1707/friend_requests', 'friend_requests.json')
      requests = @client.friend_requests(1707)
      requests.first.username.should == 'juanchez'
    end
    
    should "retrieve friends for a user" do
      stub_get('http://pengwynn:0U812@api.gowalla.com/users/1707/friends', 'friends.json')
      friends = @client.friends(1707)
      friends.size.should == 0
    end
    
    should "retrieve items for a user" do
      stub_get('http://pengwynn:0U812@api.gowalla.com/users/1707/items', 'items.json')
      items = @client.items(1707)
      items.first.issue_number.should == 27868
      items.first.name.should == 'Bowl of Noodles'
    end
    
    should "retrieve missing items for a user" do
      stub_get('http://pengwynn:0U812@api.gowalla.com/users/1707/items/missing', 'missing_items.json')
      items = @client.missing_items(1707)
      items.first.name.should == 'Torch'
    end
    
    should "retrieve vaulted items for a user" do
      stub_get('http://pengwynn:0U812@api.gowalla.com/users/1707/items/vault', 'vaulted_items.json')
      items = @client.vaulted_items(1707)
      items.first.issue_number.should == 9932
      items.first.name.should == 'Football Helmet'
    end
    
    should "retrieve pins for a user" do
      stub_get('http://pengwynn:0U812@api.gowalla.com/users/1707/pins', 'pins.json')
      pins = @client.pins(1707)
      pins.size.should == 4
      pins.first.name.should == 'Ranger'
    end
    
    should "retrieve visited spots for a user" do
      stub_get('http://pengwynn:0U812@api.gowalla.com/users/1707/visited_spots', 'visited_spots.json')
      visited_spots = @client.visited_spots(1707)
      visited_spots.size.should == 15
      visited_spots.last.should == "/spots/11300"
    end
    
    should_eventually "request a friendship with a user" do
      # POST http://api.gowalla.com/friendships/accept?user_id=104421
    end
    
    should_eventually "accept a friendship with a user" do
      
    end
    
    should "retrieve details for a spot" do
      stub_get('http://pengwynn:0U812@api.gowalla.com/spots/452593', 'spot.json')
      spot = @client.spot(452593)
      spot.name.should == "Wahoo's"
      spot.twitter_username.should == 'Wahoos512'
      spot.spot_categories.first.name.should == 'Mexican'
    end

    
    should_eventually "drop an item" do
      # POST http://api.gowalla.com/items/899654/drop
      # BODY spot_url=/spots/472093
    end
    
    should_eventually "pick up an item" do
      
    end
    

    
    should "find featured spots by latitude and longitude" do
      stub_get("http://pengwynn:0U812@api.gowalla.com/spots?featured=1&lat=%2B33.237593417&lng=-96.960559033", "spots.json")
      spots = @client.featured_spots(:lat => 33.237593417, :lng => -96.960559033)
      spots.first.name.should == 'Gnomb Bar'
      spots.first.radius_meters.should == 50
    end
    
    should "find bookmarked spots by latitude and longitude" do
      stub_get("http://pengwynn:0U812@api.gowalla.com/spots?bookmarked=1&lat=%2B33.237593417&lng=-96.960559033", "spots.json")
      spots = @client.bookmarked_spots(:lat => 33.237593417, :lng => -96.960559033)
      spots.first.name.should == 'Gnomb Bar'
      spots.first.radius_meters.should == 50
    end
    
    should "find spots by category, latitude, and longitude" do
      stub_get("http://pengwynn:0U812@api.gowalla.com/spots?category_id=13&lat=%2B33.237593417&lng=-96.960559033", "spots.json")
      spots = @client.list_spots(:lat => 33.237593417, :lng => -96.960559033, :category_id => 13)
      spots.first.name.should == 'Gnomb Bar'
      spots.first.radius_meters.should == 50
    end
    
    should "find trips by latitude and longitude" do
      stub_get("http://pengwynn:0U812@api.gowalla.com/trips?user_url=%2Fusers%2F1707&lat=%2B33.23404216&lng=-96.95513802", "find_trips.json")
      trips = @client.trips(:lat => 33.234042160, :lng => -96.955138020, :user_id => 1707)
      trips.first.name.should == 'Dallas Championship Chase'
      trips.first.spots.size.should == 3
    end
    
    should "find featured trips by latitude, longitude, and user" do
      stub_get("http://pengwynn:0U812@api.gowalla.com/trips?context=featured&user_url=%2Fusers%2F1707&lat=%2B33.23404216&lng=-96.95513802", "find_trips.json")
      trips = @client.featured_trips(:lat => 33.234042160, :lng => -96.955138020, :user_id => 1707, :context => 'featured')
      trips.first.name.should == 'Dallas Championship Chase'
      trips.first.spots.size.should == 3
    end
    
    should "find friends trips by latitude, longitude, and user" do
      stub_get("http://pengwynn:0U812@api.gowalla.com/trips?context=friends&user_url=%2Fusers%2F1707&lat=%2B33.23404216&lng=-96.95513802", "find_trips.json")
      trips = @client.friends_trips(:lat => 33.234042160, :lng => -96.955138020, :user_id => 1707, :context => 'featured')
      trips.first.name.should == 'Dallas Championship Chase'
      trips.first.spots.size.should == 3
    end
    
    
    
    should_eventually "create a spot" do
      # POST http://api.gowalla.com/spots
      # BODY lat=33.23404216&name=TreeFrog%20Studios&category_url=/categories/217&description=Children%20and%20family%20photography%20studio&lng=-96.95513802000001
    end
    
    should "check in at a spot" do
      stub_post("http://pengwynn:0U812@api.gowalla.com/checkins?spot_id=124261", "checkin.json")
      checkin = @client.checkin(124261, :lat => 39.24180603027344, :lng => -8.695899963378906)
      checkin.detail_html.should_not be_nil
    end
    
    
  end
  
  should "configure api_key, username, and password for easy access" do
    
    Gowalla.configure do |config|
      config.api_key = 'api_key'
      config.username = 'username'
      config.password = 'password'
    end

    @client = Gowalla::Client.new
    
    stub_get('http://username:password@api.gowalla.com/trips', 'trips.json')
    trips = @client.trips
    
    @client.username.should == 'username'
  end
  
  
end
