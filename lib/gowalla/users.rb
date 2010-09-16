module Gowalla
  module Users

    # Retrieve information about a specific user
    #
    # @param [String] user_id (authenticated basic auth user) User ID (screen name)
    # @return [Hashie::Mash] User info
    def user(user_id=nil)
      user_id ||= username
      connection.get("/users/#{user_id}").body
    end

    # Retrieve a list of the stamps the user has collected
    #
    # @param [String] user_id (authenticated basic auth user) User ID (screen name)
    # @param [Integer] limit (20) limit per page
    # @return [Hashie::Mash] stamps info
    def stamps(user_id=self.username, limit=20)
      response = connection.get do |req|
        req.url "/users/#{user_id}/stamps", :limit => limit
      end
      response.body.stamps
    end

    # Retrieve a list of spots the user has visited most often
    #
    # @param [String] user_id (authenticated basic auth user) User ID (screen name)
    # @return [Hashie::Mash] item info
    def top_spots(user_id=self.username)
      connection.get("/users/#{user_id}/top_spots").body.top_spots
    end


  end
end
