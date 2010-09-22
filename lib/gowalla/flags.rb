module Gowalla
  module Flags

    # Retrieve a list of flags
    #
    # @return [<Hashie::Mash>] Flag info
    def list_flags(options={})
      connection.get("/flags").body.flags
    end

    # Retrieve information about a particular flag
    #
    # @param [Integer] flag_id Flag ID
    # @return [Hashie::Mash] Flag info
    def flag(flag_id)
      connection.get("/flags/#{flag_id}").body
    end

    # Retrieve a list of flags for a particular spot
    # WARNING: This method uses calls not officially supported by Gowalla.
    #
    # @param [Integer] spot_id Spot ID
    # @return [Hashie::Mash] Array of Flags
    def spot_flags(spot_id)
      connection.get("/spots/#{spot_id}/flags").body.flags
    end

    # Create a flag on a particular spot (Reports a problem to Gowalla)
    # WARNING: This method uses calls not officially supported by Gowalla.
    #
    # @param [String] flag_type Type of flag to create: invalid,duplicate,mislocated,venue_closed,inaccurate_information
    # @param [String] description Description of the problem
    def flag_spot(spot_id, flag_type, description)
      response = connection.post do |req|
        req.url "/spots/#{spot_id}/flags/#{flag_type}"
        req.body = {:description => description}
      end
      response.body
    end

  end
end