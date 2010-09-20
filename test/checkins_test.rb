require 'helper'

class CheckinsTest < Test::Unit::TestCase

  context "When using the Gowalla API and working with checkins" do
    setup do
      @client = gowalla_test_client
    end

    should "fetch info for a checkin" do
      stub_get("http://pengwynn:0U812@api.gowalla.com/checkins/88", "checkin.json")
      checkin = @client.checkin_info(88)
      checkin.spot.name.should == 'Movie Tavern'
      checkin.message.should == 'There sending us Back-- to the Future!'
    end
  end

end
