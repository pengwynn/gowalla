require 'helper'

class ItemsTest < Test::Unit::TestCase

  context "When using the Gowalla API and working with items" do
    setup do
      @client = gowalla_test_client
    end

    should "retrieve information about a specific item" do
      stub_get('http://pengwynn:0U812@api.gowalla.com/items/607583', 'item.json')
      item = @client.item(607583)
      item.issue_number.should == 13998
      item.name.should == 'Sweets'
      item.determiner.should == 'some'
    end

    should "retrieve events associated with a specific item" do
      stub_get('http://pengwynn:0U812@api.gowalla.com/items/607583/events', 'item_events.json')
      events = @client.item_events(607583)
      events.first.spot.name = 'Jerusalem Bakery'
      events.first.user.first_name = 'Scott'
    end
  end

end
