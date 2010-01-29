# Gowalla

Ruby wrapper for (most) of the (unreleased) Gowalla API.

*Note: The Gowalla API is unannounced. This wrapper consumes what I've been able to sniff out using [Charles Proxy](http://www.charlesproxy.com/) and my iPhone.*

## Installation

    sudo gem install gowalla
    
## Usage

### Public requests

    >> Gowalla.user('pengwynn')
    => <#Hashie::Mash accept_url="/friendships/accept?user_id=1707" activity_url="/users/1707/events" bio="Web designer and Ruby developer." events_url="/users/1707/events" fb_id=605681706 first_name="Wynn" friends_count=27 friends_only=false friends_url="/users/1707/friends" hometown="Aubrey, TX" image_url="http://s3.amazonaws.com/static.gowalla.com/users/1707-standard.jpg?1262011383" is_friend=false items_count=5 items_url="/users/1707/items" last_name="Netherland" last_visit=<#Hashie::Mash comment="Closing every account I have " created_at="2010/01/26 15:31:46 +0000" spot=<#Hashie::Mash image_url="http://static.gowalla.com/categories/186-standard.png" name="Bank Of America" small_image_url="http://static.gowalla.com/categories/186-small-standard.png" url="/spots/164052">> name="Wynn Netherland" pins_count=3 pins_url="/users/1707/pins" reject_url="/friendships/reject?user_id=1707" request_url="/friendships/request?user_id=1707" stamps_count=15 stamps_url="/users/1707/stamps" top_spots_url="/users/1707/top_spots" twitter_username="pengwynn" url="/users/1707" username="pengwynn" vaulted_kinds_count=0 visited_spots_count=15 website="http://wynnnetherland.com">
    
### Authenticated requests

    >> gowalla = Gowalla::Client.new('pengwynn', 'somepassword')

#### Details for the current user

    >> gowalla.user
    
#### Details for another user

    >> gowalla.user('bradleyjoyce')
    >> gowalla.user(1707)
    
Docs to come once the API is released. For now check out the source.

TODO:

* DEFERRED: When hitting the Gowalla API authenticated should request a friendship with a user.
* DEFERRED: When hitting the Gowalla API authenticated should accept a friendship with a user.
* DEFERRED: When hitting the Gowalla API authenticated should drop an item.
* DEFERRED: When hitting the Gowalla API authenticated should pick up an item.
* DEFERRED: When hitting the Gowalla API authenticated should find spots by latitude and longitude.
* DEFERRED: When hitting the Gowalla API authenticated should find featured spots by latitude and longitude.
* DEFERRED: When hitting the Gowalla API authenticated should find bookmarked spots by latitude and longitude.
* DEFERRED: When hitting the Gowalla API authenticated should find spots by category, latitude, and longitude.
* DEFERRED: When hitting the Gowalla API authenticated should find trips by latitude and longitude.
* DEFERRED: When hitting the Gowalla API authenticated should find featured trips by latitude, longitude, and user.
* DEFERRED: When hitting the Gowalla API authenticated should find friends trips by latitude, longitude, and user.
* DEFERRED: When hitting the Gowalla API authenticated should list categories.
* DEFERRED: When hitting the Gowalla API authenticated should create a spot.
* DEFERRED: When hitting the Gowalla API authenticated should check in at a spot

## Note on Patches/Pull Requests
 
* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a
  future version unintentionally.
* Commit, do not mess with rakefile, version, or history.
  (if you want to have your own version, that is fine but
   bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

## Copyright

Copyright (c) 2010 Wynn Netherland. See LICENSE for details.
