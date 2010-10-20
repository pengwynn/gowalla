require 'helper'

class FlagsTest < Test::Unit::TestCase

  context "When using the Gowalla API and working with flags" do
    setup do
      @client = gowalla_test_client
    end

    should "retrieve a list of flags" do
      stub_get("https://pengwynn:0U812@api.gowalla.com/flags", "flags.json")
      flags = @client.list_flags
      flags.first.spot.name.should == 'Wild Gowallaby #1'
      flags.first.user.url.should == '/users/340897'
      flags.first[:type].should == 'invalid'
      flags.first.status.should == 'open'
    end

    should "retrieve information about a specific flag" do
      stub_get("https://pengwynn:0U812@api.gowalla.com/flags/1", "flag.json")
      flag = @client.flag(1)
      flag.spot.name.should == 'Wild Gowallaby #1'
      flag.user.url.should == '/users/340897'
      flag[:type].should == 'invalid'
      flag.status.should == 'open'
    end


    should "retrieve flags associated with that spot" do
      stub_get("https://pengwynn:0U812@api.gowalla.com/spots/1/flags", "flags.json")
      flags = @client.spot_flags(1)
      flags.first.spot.name.should == 'Wild Gowallaby #1'
      flags.first.user.url.should == '/users/340897'
      flags.first[:type].should == 'invalid'
      flags.first.status.should == 'open'
    end

    should "set a flag on a specific spot" do
      url = "https://pengwynn:0U812@api.gowalla.com/spots/1/flags/invalid"
      stub_post(url, "flag_created.json")
      response = @client.flag_spot(1, 'invalid', 'my problem description')
      response.result.should == 'flag created'
    end

  end
end
