module Gowalla
  module Checkins

    # Fetch info for a checkin
    #
    # @param [Integer] id Checkin ID
    # @return [Hashie::Mash] checkin info
    def checkin_info(id)
      connection.get("/checkins/#{id}").body
    end

    # Check in at a spot
    #
    # @option details [Integer] :spot_id Spot ID
    # @option details [Float] :lat Latitude of spot
    # @option details [Float] :lng Longitude of spot
    # @option details [String] :comment Checkin comment
    # @option details [Boolean] :post_to_twitter Post Checkin to Twitter
    # @option details [Boolean] :post_to_facebook Post Checkin to Facebook
    def checkin(details={})
      checkin_path = "/checkins"
      checkin_path += "/test" if Gowalla.test_mode?
      response = connection.post do |req|
        req.url checkin_path
        req.body = details
      end
      response.body
    end

  end
end