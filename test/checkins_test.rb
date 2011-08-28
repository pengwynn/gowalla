require 'helper'

class CheckinsTest < Test::Unit::TestCase

  should "fetch info for a checkin" do
    client = gowalla_basic_client

    stub_request("https://pengwynn:0U812@api.gowalla.com/checkins/88", "checkin_info.json")
    checkin = client.checkin_info(88)
    checkin.spot.name.should == 'Movie Tavern'
    checkin.message.should == 'There sending us Back-- to the Future!'
  end

  should "create a checkin" do
    client = gowalla_oauth_client

    stub_request("https://api.gowalla.com/checkins?oauth_token=0U812", "checkin.json")
    checkin = client.checkin \
                :spot_id => 18568,
                :lat => 33.237593417,
                :lng => -96.960559033,
                :comment => 'visiting',
                :post_to_facebook => 0,
                :post_to_twitter => 0
    checkin.message.should == 'coffee test'
  end

end
