require 'helper'

class UsersTest < Test::Unit::TestCase

  context "When using the Gowalla API and working with Users" do
    setup do
      @client = gowalla_test_client
    end

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

    should "retrieve a list of the user's most recent checkins" do
      stub_get('http://pengwynn:0U812@api.gowalla.com/users/1707/events', 'user_events.json')
      user_events = @client.user_events(1707)
      user_events.size.should == 10
      user_events.first.url.should == '/checkins/18863224'
      user_events.first.spot.name.should == "Barktoberfest"
    end

    should "retrieve a list of items the user is carrying" do
      stub_get('http://pengwynn:0U812@api.gowalla.com/users/sco/items?context=vault', 'items.json')
      items = @client.user_items('sco', 'vault')
      items.first.issue_number.should == 27868
      items.first.name.should == 'Bowl of Noodles'
    end

    should "retrieve a list of friends for the user" do
      stub_get('http://pengwynn:0U812@api.gowalla.com/users/sco/friends', 'users.json')
      users = @client.friends('sco')
      users.first.first_name.should == 'Chalkbot'
    end

    should "retrieve a list of trips created by the user" do
      stub_get('http://pengwynn:0U812@api.gowalla.com/users/sco/trips', 'trips.json')
      trips = @client.user_trips('sco')
      trips.first.name.should == 'London Pub Crawl'
      trips.first.spots.first.url.should == '/spots/164009'
    end

    should "retrieve a list of photos taken by the user" do
      stub_get('http://pengwynn:0U812@api.gowalla.com/users/sco/photos', 'photos.json')
      photos = @client.user_photos('sco')
      #photos.first.type.should == 'photo'
      photos.first.photo_urls.square_50.should == 'http://static.gowalla.com/photos/912078_square_50.jpg'
    end

    should "retrieve a list of pins collected by the user" do
      stub_get('http://pengwynn:0U812@api.gowalla.com/users/sco/pins', 'pins.json')
      pins = @client.user_pins('sco')
      pins.first.name.should == '110 Film'
      #pins.first.trip.type.should == 'challenge'
    end

  end

end