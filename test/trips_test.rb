require 'helper'

class TripsTest < Test::Unit::TestCase

  context "When using the Gowalla API and working with trips" do
    setup do
      @client = gowalla_test_client
    end

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
