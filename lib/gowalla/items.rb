module Gowalla
  module Items

    # Retrieve information about a specific item
    #
    # @param [Integer] id Item ID
    # @return [Hashie::Mash] item info
    def item(id)
      connection.get("/items/#{id}").body
    end

  end
end