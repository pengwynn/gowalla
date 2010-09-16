module Gowalla
  module Spots

    # Retrieve a list of spots within a specified distance of a location
    #
    # @option options [Float] :lat Latitude of search location
    # @option options [Float] :lng Longitude of search location
    # @option options [Integer] :radius Search radius (in meters)
    # @return [Hashie::Mash] spots info
    def list_spots(options={})
      query = format_geo_options(options)
      response = connection.get do |req|
        req.url "/spots", query
      end
      response.body.spots
    end

    # Retrieve information about a specific spot
    #
    # @param [Integer] spot_id Spot ID
    # @return [Hashie::Mash] Spot info
    def spot(spot_id)
      connection.get("/spots/#{spot_id}").body
    end

    # Retrieve a list of check-ins at a particular spot. Shows only the activity that is visible to a given user.
    #
    # @param [Integer] spot_id Spot ID
    # @return [Hashie::Mash] Spot info
    def spot_events(spot_id)
      connection.get("/spots/#{spot_id}/events").body.activity
    end

    # Retrieve a list of items available at a particular spot
    #
    # @param [Integer] spot_id Spot ID
    # @return [Hashie::Mash] Spot info
    def spot_items(spot_id)
      connection.get("/spots/#{spot_id}/items").body.items
    end

    # Lists all spot categories
    #
    # @return [<Hashie::Mash>] category info
    def categories
      connection.get("/categories").body.spot_categories
    end

    # Retrieve information about a specific category
    #
    # @param [Integer] id Category ID
    # @return [Hashie::Mash] category info
    def category(id)
      connection.get("/categories/#{id}").body
    end

    # Retrieve a list of flags for a particular spot
    #
    # @param [Integer] spot_id Spot ID
    # @return [Hashie::Mash] Array of Flags
    def spot_flags(spot_id)
      connection.get("/spots/#{spot_id}/flags").body.flags
    end

  end
end