require 'helper'

class SpotsTest < Test::Unit::TestCase

  context "When using the Gowalla API and working with Spots" do
    setup do
      @client = gowalla_test_client
    end

    should "Retrieve a list of spots within a specified distance of a location" do
      stub_get("https://pengwynn:0U812@api.gowalla.com/spots?lat=%2B33.237593417&lng=-96.960559033&radius=50", "spots.json")
      spots = @client.list_spots(:lat => 33.237593417, :lng => -96.960559033, :radius => 50)
      spots.first.name.should == 'Gnomb Bar'
      spots.first.radius_meters.should == 50
    end

    should "Retrieve a list of spots within a specified bounds" do
      stub_get("https://pengwynn:0U812@api.gowalla.com/spots?sw=%2839.25565142103586%2C%20-8.717308044433594%29&nw=%2839.31411296530539%2C%20-8.490715026855469%29", "spots.json")
      spots = @client.list_spots(:sw => "(39.25565142103586, -8.717308044433594)", :nw => "(39.31411296530539, -8.490715026855469)")
      spots.first.name.should == 'Gnomb Bar'
    end

    should "Retrieve information about a specific spot" do
      stub_get('https://pengwynn:0U812@api.gowalla.com/spots/18568', 'spot.json')
      spot = @client.spot(18568)
      spot.name.should == "Wahoo's"
      spot.twitter_username.should == 'Wahoos512'
      spot.spot_categories.first.name.should == 'Mexican'
    end

    should "retrieve a list of check-ins at a particular spot. Shows only the activity that is visible to a given user" do
      stub_get('https://pengwynn:0U812@api.gowalla.com/spots/452593/events', 'spot_events.json')
      events = @client.spot_events(452593)
      events.first[:type].should == 'checkin'
      events.first.user.last_name.should == 'Mack'
    end

    should "retrieve a list of items available at a particular spot" do
      stub_get('https://pengwynn:0U812@api.gowalla.com/spots/18568/items', 'items.json')
      items = @client.spot_items(18568)
      items.first.issue_number.should == 27868
      items.first.name.should == 'Bowl of Noodles'
    end

    should "lists all spot categories" do
      stub_get("https://pengwynn:0U812@api.gowalla.com/categories", "categories.json")
      categories = @client.categories
      categories.size.should == 9
      categories.first.name.should == 'Architecture & Buildings'
      categories.first.description.should == 'Bridge, Corporate, Home, Church, etc.'
      categories.first.spot_categories.size.should == 15
      categories.first.spot_categories.first.name.should == 'Bridge'
    end

    should "retrieve information about a specific category" do
      stub_get("https://pengwynn:0U812@api.gowalla.com/categories/1", "category.json")
      category = @client.category(1)
      category.name.should == 'Coffee Shop'
    end

    should "retrieve photos taken at a spot" do
      stub_get('https://pengwynn:0U812@api.gowalla.com/spots/18568/photos', 'photos.json')
      photos = @client.spot_photos(18568)
      #photos.first.type.should == 'photo'
      photos.first.photo_urls.square_50.should == 'http://static.gowalla.com/photos/912078_square_50.jpg'
    end

  end

end