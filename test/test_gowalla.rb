require 'helper'

class TestGowalla < Test::Unit::TestCase

  context "When hitting the Gowalla API authenticated" do
    setup do
      @client = Gowalla::Client.new('pengwynn', '0U812')
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
      events.first.comment.should == 'Closing every account I have '
      events.last.spot.name.should == 'Grape Creek Vineyards'
    end
    
    should "retrieve events for a user's friends" do
      stub_get('http://pengwynn:0U812@api.gowalla.com/visits/recent', 'events.json')
      events = @client.friends_events
      events.first.comment.should == 'Closing every account I have '
      events.last.spot.name.should == 'Grape Creek Vineyards'
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
      items.size.should == 5
      items.first.name.should == 'Stationery'
    end
    
    should "retrieve pins for a user" do
      stub_get('http://pengwynn:0U812@api.gowalla.com/users/1707/pins', 'pins.json')
      pins = @client.pins(1707)
      pins.size.should == 4
      pins.first.name.should == 'Ranger'
    end
    
    should "retrieve stamps for a user" do
      stub_get('http://pengwynn:0U812@api.gowalla.com/users/1707/stamps', 'stamps.json')
      stamps = @client.stamps(1707)
      stamps.size.should == 15
      stamps.first.name.should == 'Bank Of America'
      stamps.first.tier.should == 2
    end
    
    should "retrieve top spots for a user" do
      stub_get('http://pengwynn:0U812@api.gowalla.com/users/1707/top_spots', 'top_spots.json')
      top_spots = @client.top_spots(1707)
      top_spots.size.should == 10
      top_spots.first.name.should == 'Bank Of America'
      top_spots.first.visits_count.should == "1"
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
    
    should "retrieve details for a trip" do
      stub_get('http://pengwynn:0U812@api.gowalla.com/trips/1', 'trip.json')
      trip = @client.trip(1)
      trip.creator.name.should == 'Team Gowalla'
      trip.map_bounds.east.should == -63.457031000000001
    end
    
    should "retrieve details for a spot" do
      stub_get('http://pengwynn:0U812@api.gowalla.com/spots/452593', 'spot.json')
      spot = @client.spot(452593)
      spot.name.should == 'Paloma Creek Elementary'
      spot.categories.first.name.should == 'Other - College & Education'
    end
    
    should "retrieve events for a spot" do
      stub_get('http://pengwynn:0U812@api.gowalla.com/spots/452593/events', 'events.json')
      events = @client.spot_events(452593)
      events.first.comment.should == 'Closing every account I have '
      events.last.spot.name.should == 'Grape Creek Vineyards'
    end
    
    should_eventually "drop an item" do
      # POST http://api.gowalla.com/items/899654/drop
      # BODY spot_url=/spots/472093
    end
    
    should_eventually "pick up an item" do
      
    end
    
    should "find spots by latitude and longitude" do
      stub_get("http://pengwynn:0U812@api.gowalla.com/spots?lat=%2B33.237593417&lng=-96.960559033", "spots.json")
      spots = @client.spots(:lat => 33.237593417, :lng => -96.960559033)
      spots.first.name.should == 'Paloma Creek Elementary'
      spots.first.radius.should == 50
    end
    
    should "find featured spots by latitude and longitude" do
      stub_get("http://pengwynn:0U812@api.gowalla.com/spots?featured=1&lat=%2B33.237593417&lng=-96.960559033", "spots.json")
      spots = @client.featured_spots(:lat => 33.237593417, :lng => -96.960559033)
      spots.first.name.should == 'Paloma Creek Elementary'
      spots.first.radius.should == 50
    end
    
    should "find bookmarked spots by latitude and longitude" do
      stub_get("http://pengwynn:0U812@api.gowalla.com/spots?bookmarked=1&lat=%2B33.237593417&lng=-96.960559033", "spots.json")
      spots = @client.bookmarked_spots(:lat => 33.237593417, :lng => -96.960559033)
      spots.first.name.should == 'Paloma Creek Elementary'
      spots.first.radius.should == 50
    end
    
    should "find spots by category, latitude, and longitude" do
      stub_get("http://pengwynn:0U812@api.gowalla.com/spots?category_id=13&lat=%2B33.237593417&lng=-96.960559033", "spots.json")
      spots = @client.spots(:lat => 33.237593417, :lng => -96.960559033, :category_id => 13)
      spots.first.name.should == 'Paloma Creek Elementary'
      spots.first.radius.should == 50
    end
    
    should "find trips by latitude and longitude" do
      stub_get("http://pengwynn:0U812@api.gowalla.com/trips?user_url=%2Fusers%2F1707&lat=%2B33.23404216&lng=-96.95513802", "find_trips.json")
      trips = @client.trips(:lat => 33.234042160, :lng => -96.955138020, :user_id => 1707)
      trips.first.name.should == 'Dallas Championship Chase'
      trips.first.spots.size.should == 3
      trips.first.published?.should == true
    end
    
    should "find featured trips by latitude, longitude, and user" do
      stub_get("http://pengwynn:0U812@api.gowalla.com/trips?context=featured&user_url=%2Fusers%2F1707&lat=%2B33.23404216&lng=-96.95513802", "find_trips.json")
      trips = @client.featured_trips(:lat => 33.234042160, :lng => -96.955138020, :user_id => 1707, :context => 'featured')
      trips.first.name.should == 'Dallas Championship Chase'
      trips.first.spots.size.should == 3
      trips.first.published?.should == true    
    end
    
    should "find friends trips by latitude, longitude, and user" do
      stub_get("http://pengwynn:0U812@api.gowalla.com/trips?context=friends&user_url=%2Fusers%2F1707&lat=%2B33.23404216&lng=-96.95513802", "find_trips.json")
      trips = @client.friends_trips(:lat => 33.234042160, :lng => -96.955138020, :user_id => 1707, :context => 'featured')
      trips.first.name.should == 'Dallas Championship Chase'
      trips.first.spots.size.should == 3
      trips.first.published?.should == true    
    end
    
    should "list categories" do
      stub_get("http://pengwynn:0U812@api.gowalla.com/categories", "categories.json")
      categories = @client.categories
      categories.size.should == 9
      categories.first.name.should == 'Architecture & Buildings'
      categories.first.description.should == 'Bridge, Corporate, Home, Church, etc.'
      categories.first.categories.size.should == 15
      categories.first.categories.first.name.should == 'Bridge'
    end
    
    
    should_eventually "create a spot" do
      # POST http://api.gowalla.com/spots
      # BODY lat=33.23404216&name=TreeFrog%20Studios&category_url=/categories/217&description=Children%20and%20family%20photography%20studio&lng=-96.95513802000001
    end
    
    should_eventually "check in at a spot" do
      # POST http://api.gowalla.com/visits?spot_id=472093
      # BODY fb_id=605681706&lat=33.23404216&accuracy=2055&post_to_facebook=0&fb_session_key=976e56d6baa517cfe77eadfc-605681706&lng=-96.95513802000001&comment=Testing%20Gowalla%20API%20&post_to_twitter=1
    end
    
    
  end
  
  context "when hitting the Gowalla API unauthenticated" do


    should "retrieve details for a user" do
      stub_get('/users/1707', 'user.json')
      user = Gowalla.user(1707)
      user.bio.should == "Web designer and Ruby developer."
      user.stamps_count.should == 15
    end
    
    should "retrieve events for a user" do
      stub_get('/users/1707/events', 'events.json')
      events = Gowalla.events(1707)
      events.first.comment.should == 'Closing every account I have '
      events.last.spot.name.should == 'Grape Creek Vineyards'
    end
    
    should "retrieve details for a trip" do
      stub_get('/trips/1', 'trip.json')
      trip = Gowalla.trip(1)
      trip.creator.name.should == 'Team Gowalla'
      trip.map_bounds.east.should == -63.457031000000001
    end
    
    should "retrieve details for a spot" do
      stub_get('/spots/452593', 'spot.json')
      spot = Gowalla.spot(452593)
      spot.name.should == 'Paloma Creek Elementary'
      spot.categories.first.name.should == 'Other - College & Education'
    end
    
    should "retrieve events for a spot" do
      stub_get('/spots/452593/events', 'events.json')
      events = Gowalla.spot_events(452593)
      events.first.comment.should == 'Closing every account I have '
      events.last.spot.name.should == 'Grape Creek Vineyards'
    end
    
  end
  
  
end
