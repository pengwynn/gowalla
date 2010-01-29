module Gowalla
  
  class Client
    include HTTParty
    format :json
    base_uri "http://api.gowalla.com"
    headers({'Accept' => 'application/json', "User-Agent" => 'Ruby gem'})
    
    attr_reader :username
    
    def initialize(username=nil, password=nil)
      @username = username
      self.class.basic_auth(@username, password) unless @username.nil?
    end
    
    def user(user_id="me")
      mashup(self.class.get("/users/#{user_id}"))
    end
    
    def events(user_id=self.username)
      mashup(self.class.get("/users/#{user_id}/events")).events
    end
    
    def friends_events
      mashup(self.class.get("/visits/recent")).events
    end
    
    def friend_requests(user_id=self.username)
      mashup(self.class.get("/users/#{user_id}/friend_requests")).friends_needing_approval
    end
    
    def friends(user_id=self.username)
      mashup(self.class.get("/users/#{user_id}/friends")).friends
    end
    
    def items(user_id=self.username)
      mashup(self.class.get("/users/#{user_id}/items"))
    end
    
    def pins(user_id=self.username)
      mashup(self.class.get("/users/#{user_id}/pins"))
    end
    
    def stamps(user_id=self.username)
      mashup(self.class.get("/users/#{user_id}/stamps"))
    end
    
    def top_spots(user_id=self.username)
      mashup(self.class.get("/users/#{user_id}/top_spots"))
    end
    
    def visited_spots(user_id=self.username)
      mashup(self.class.get("/users/#{user_id}/visited_spots"))
    end
    
    def trip(trip_id)
      mashup(self.class.get("/trips/#{trip_id}"))
    end
    
    def spot(spot_id)
      mashup(self.class.get("/spots/#{spot_id}"))
    end
    
    def spot_events(spot_id)
      mashup(self.class.get("/spots/#{spot_id}/events")).events
    end
    
    private
    
      def mashup(response)
        case response.code
        when 200
          if response.is_a?(Hash)
            Hashie::Mash.new(response)
          else
            if response.first.is_a?(Hash)
              response.map{|item| Hashie::Mash.new(item)}
            else
              response
            end
          end
        end
      end
    
  end
  
end