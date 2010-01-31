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
    
    def user(user_id=self.username)
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
    
    def spots(options={})
      query = format_geo_options(options)
      mashup(self.class.get("/spots", :query => query))
    end
    
    def featured_spots(options={})
      spots(options.merge(:featured => 1))
    end
    
    def bookmarked_spots(options={})
      spots(options.merge(:bookmarked => 1))
    end
    
    def trips(options={})
      if user_id = options.delete(:user_id)
        options[:user_url] = "/users/#{user_id}"
      end
      query = format_geo_options(options)
      mashup(self.class.get("/trips", :query => query))
    end
    
    def featured_trips(options={})
      trips(options.merge(:context => 'featured'))
    end
    
    def friends_trips(options={})
      trips(options.merge(:context => 'friends'))
    end
    
    def categories
      mashup(self.class.get("/categories"))
    end
    
    private
    
      def format_geo_options(options={})
        options[:lat] = "+#{options[:lat]}" if options[:lat] > 0
        options[:lng] = "+#{options[:lng]}" if options[:lng] > 0
        options
      end
    
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