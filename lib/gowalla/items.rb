module Gowalla
  module Items

    # Retrieve information about a specific item
    #
    # @param [Integer] id Item ID
    # @return [Hashie::Mash] item info
    def item(id)
      connection.get("/items/#{id}").body
    end

    # Retrieve events connected to a specific item
    # WARNING: This method uses calls not officially supported by Gowalla.
    #
    # @param [Integer] id Item ID
    # @return [Hashie::Mash] Array of events
    def item_events(id)
      connection.get("/items/#{id}/events").body.events
    end

  end
end