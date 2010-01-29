require 'helper'

class TestGowalla < Test::Unit::TestCase

  context "When hitting the Gowalla API authenticated" do
    setup do
      @client = Gowalla::Client.new('pengwynn', '0U812')
    end
    
    should "retrieve details for the current user" do
      stub_get('http://pengwynn:0U812@api.gowalla.com/users/me', 'me.json')
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
      
    end
    
    should_eventually "pick up an item" do
      
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
