module Gowalla
  module Trips

    # List of trips
    #
    # @return [<Hashie::Mash>] trip info
    def trips(options={})
      if user_id = options.delete(:user_id)
        options[:user_url] = "/users/#{user_id}"
      end
      query = format_geo_options(options)
      response = connection.get do |req|
        req.url "/trips", query
      end
      response.body.trips
    end

    # Retrieve information about a specific trip
    #
    # @param [Integer] trip_id Trip ID
    # @return [Hashie::Mash] trip info
    def trip(trip_id)
      connection.get("/trips/#{trip_id}").body
    end

  end
end