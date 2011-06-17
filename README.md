# Gowalla

Ruby wrapper for the [Gowalla API](http://gowalla.com/api/docs).

## Installation

    sudo gem install gowalla

## Get your API key

Be sure and get your API key: [http://gowalla.com/api/keys](http://gowalla.com/api/keys)

## Usage

### Instantiate a client (Basic Auth)

    gowalla = Gowalla::Client.new(:username => 'pengwynn', :password => 'somepassword', :api_key => 'your_api_key')

### or configure once

    Gowalla.configure do |config|
      config.api_key = 'your_api_key'
      config.username = 'pengwynn'
      config.password = 'somepassword'
    end
    gowalla = Gowalla::Client.new

### Instantiate a client (OAuth2)

For OAuth2, you'll need to specify a callback URL when you [set up your app and get your API keys](http://gowalla.com/api/keys).

Let's create the client in a protected method in our controller:

    protected
      def client
        Gowalla::Client.new (
          :api_key     => "your_api_key",
          :api_secret  => "your_api_secret",
          :access_token => session[:access_token]
        )
      end

We need to get an access token. Perhaps in an a before filter where you need to access Gowalla:

    redirect(@client.web_server.authorize_url(:redirect_uri => redirect_uri, :state => 1))

or if you need read-write access:

    redirect(@client.web_server.authorize_url(:redirect_uri => redirect_uri, :state => 1, :scope => 'read-write))

You'll need a callback route to catch the code coming back from Gowalla after a user grants you access and this must match what you specified when you created your app on Gowalla:

    get '/auth/gowalla/callback' do
      access_token = client.web_server.get_access_token(
        params[:code],
        :redirect_uri => gowalla_callback_url
      )

      if access_token.expires_at < Time.now.utc
        access_token = client.web_server.refresh_access_token(
          session[:refresh_token]
        )
      end

      session[:access_token] = access_token.token
      session[:refresh_token] = access_token.refresh_token

      if session[:access_token]
        redirect '/auth/gowalla/test'
      else
        "Error retrieving access token."
      end
    end

Now that we have an access token we can use the client to make calls, just like we would with Basic Auth. You can checkout a basic [Sinatra example](http://gist.github.com/454283).

#### Examples

    gowalla.user('pengwynn')
    => <#Hashie::Mash accept_url="/friendships/accept?user_id=1707" activity_url="/users/1707/events" bio="Web designer and Ruby developer." events_url="/users/1707/events" fb_id=605681706 first_name="Wynn" friends_count=27 friends_only=false friends_url="/users/1707/friends" hometown="Aubrey, TX" image_url="http://s3.amazonaws.com/static.gowalla.com/users/1707-standard.jpg?1262011383" is_friend=false items_count=5 items_url="/users/1707/items" last_name="Netherland" last_visit=<#Hashie::Mash comment="Closing every account I have " created_at="2010/01/26 15:31:46 +0000" spot=<#Hashie::Mash image_url="http://static.gowalla.com/categories/186-standard.png" name="Bank Of America" small_image_url="http://static.gowalla.com/categories/186-small-standard.png" url="/spots/164052"name="Wynn Netherland" pins_count=3 pins_url="/users/1707/pins" reject_url="/friendships/reject?user_id=1707" request_url="/friendships/request?user_id=1707" stamps_count=15 stamps_url="/users/1707/stamps" top_spots_url="/users/1707/top_spots" twitter_username="pengwynn" url="/users/1707" username="pengwynn" vaulted_kinds_count=0 visited_spots_count=15 website="http://wynnnetherland.com">

Details for the current user

    gowalla.user

Details for another user

    gowalla.user('bradleyjoyce')
    gowalla.user(1707)

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
