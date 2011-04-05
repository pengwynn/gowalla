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

    # Retrieve a list of spot urls the user has visited
    #
    # @param [String] user_id (authenticated basic auth user) User ID (screen name)
    # @return [Hashie::Mash] spot urls
    def visited_spots_urls(user_id=self.username)
      connection.get("/users/#{user_id}/visited_spots_urls").body.urls
    end

    # Retrieve a list of the user's most recent checkins.
    #
    # @param [String] user_id (authenticated basic auth user) User ID (screen name)
    # @return [Hashie::Mash] Array of checkin events
    def user_events(user_id=self.username,page=1)
      connection.get("/users/#{user_id}/events?page=#{page}").body.activity
    end

    # Retrieve a list of items the user is carrying
    # WARNING: This method uses calls not officially supported by Gowalla.
    #
    # @param [String] user_id (authenticated basic auth user) User ID (screen name)
    # @param [String] context The type of item: pack, vault, missing
    # @return [Hashie::Mash] items info
    def user_items(user_id=self.username, context='pack')
      response = connection.get do |req|
        req.url "/users/#{user_id}/items", :context => context
      end
      response.body.items
    end

    # Retrieve a list of photos the user has taken
    # WARNING: This method uses calls not officially supported by Gowalla.
    #
    # @param [String] user_id (authenticated basic auth user) User ID (screen name)
    # @return [Hashie::Mash] photos info
    def user_photos(user_id=self.username)
      connection.get("/users/#{user_id}/photos").body.activity
    end

    # Retrieve a list of trips the user has created
    # WARNING: This method uses calls not officially supported by Gowalla.
    #
    # @param [String] user_id (authenticated basic auth user) User ID (screen name)
    # @return [Hashie::Mash] trips info
    def user_trips(user_id=self.username)
      connection.get("/users/#{user_id}/trips").body.trips
    end

    # Retrieve a list of pins the user has collected
    # WARNING: This method uses calls not officially supported by Gowalla.
    #
    # @param [String] user_id (authenticated basic auth user) User ID (screen name)
    # @return [Hashie::Mash] pins info
    def user_pins(user_id=self.username)
      connection.get("/users/#{user_id}/pins").body.pins
    end

    # Retrieve a list of friends for the user
    # WARNING: This method uses calls not officially supported by Gowalla.
    #
    # @param [String] user_id (authenticated basic auth user) User ID (screen name)
    # @return [Hashie::Mash] friends info
    def friends(user_id=self.username)
      connection.get("/users/#{user_id}/friends").body.users
    end

  end
end
