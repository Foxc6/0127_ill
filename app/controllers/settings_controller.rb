class SettingsController < ApplicationController

  def index
    @options = Option.all
  end

  def linkedin_callback
    client = LinkedIn::Client.new(ENV['LINKEDIN_CONSUMER_KEY'], ENV['LINKEDIN_CONSUMER_SECRET'])
    if session[:auth_token].nil?
      pin = params[:oauth_verifier]
      auth_token, auth_secret = client.authorize_from_request(session[:rtoken], session[:rsecret], pin)
      option = Option.new
      option.key = 'linkedin_auth_token'
      option.value = auth_token
      option.save
      option_two = Option.new
      option_two.key = 'linkedin_auth_secret'
      option_two.value = auth_secret
      session[:auth_token] = auth_token
      session[:auth_secret] = auth_secret
    else
      client.authorize_from_access(session[:auth_token], session[:auth_secret])
    end
  end

  def linkedin_company
  end

  def linkedin

  end

  def auth
    client = LinkedIn::Client.new(ENV['LINKEDIN_CONSUMER_KEY'], ENV['LINKEDIN_CONSUMER_SECRET'])
    request_token = client.request_token(:oauth_callback =>
                                      "#{request.original_url}/settings/social-networks/linkedin", :scope => "r_fullprofile+r_emailaddress")
    session[:rtoken] = request_token.token
    session[:rsecret] = request_token.secret
    redirect_to client.request_token.authorize_url
  end

  def facebook
    @graph = Koala::Facebook::API.new
    app_id = ENV['FACEBOOK_APP_ID']
    app_secret = ENV['FACEBOOK_APP_SECRET']
    callback_url = "localhost:3000/settings/social-networks/facebook"
    @oauth = Koala::Facebook::OAuth.new(app_id, app_secret, callback_url)
    @api = Koala::Facebook::API.new(@oauth)
  end

  def facebook_auth
    app_id = ENV['FACEBOOK_APP_ID']
    app_secret = ENV['FACEBOOK_APP_SECRET']
    callback_url = "localhost:3000/settings/social-networks/facebook"
    @oauth = Koala::Facebook::OAuth.new(app_id, app_secret, callback_url)
    redirect_to settings_social_networks_facebook_path(@oauth)
  end

  def twitter

  end


  def pinterest
    id = ENV['PINTREST_ID']
    secret = ENV['PINTREST_SECRET']
    token = ENV['PINTREST_TOKEN']
  end

  def instagram
    id = ENV['INSTAGRAM_ID']
    secret = ENV['INSTAGRAM_SECRET']
    redirect_url = "http://localhost:3000/settings/social-networks/instagram"
  end

  def auth_instagram
    Instagram.configure do |config|
      config.client_id = ENV['INSTAGRAM_ID']
      config.client_secret = ENV['INSTAGRAM_SECRET']
      # For secured endpoints only
      #config.client_ips = '<Comma separated list of IPs>'
    end
    url = "https://api.instagram.com/oauth/authorize/?client_id=[clientID]&redirect_uri=http://localhost&response_type=token"
    @callback_url = "http://localhost:3000/settings/social-networks/instagram/insta_callback"
    redirect_to Instagram.authorize_url(:redirect_uri => @callback_url, :scope => 'public_content')
  end

  def insta_callback
    if session[:insta_token].nil?
      @callback_url = "http://localhost:3000/settings/social-networks/instagram/insta_callback"
      response = Instagram.get_access_token(params[:code], :redirect_uri => @callback_url)
      session[:insta_token] = response.access_token
      @client = Instagram.client(:access_token => session[:insta_token])
    else
      @client = Instagram.client(:access_token => session[:insta_token])
    end
    username = "guymariano"
    @token = session[:insta_token]
    @user_search_url = "https://api.instagram.com/v1/users/search?q=#{username}&access_token=#{@token}"
    @follower_count_url = "https://api.instagram.com/v1/users/{user-id}/?access_token=ACCESS-TOKEN"
  end

  def tumblr
    key = ENV['TUMBLR_KEY']
    secret = ENV['TUMBLR_SECRET']
    site = "http://www.tumblr.com"
    client = Tumblr::Client.new()
    pin = params[:oauth_verifier]
    # auth_token, auth_secret = client.authorize_from_request(key, secret, pin)

    # puts 'Setting up request'
    @consumer = OAuth::Consumer.new(key, secret, { :site => site,
                                                     :request_token_path => '/oauth/request_token',
                                                     :authorize_path => '/oauth/authorize',
                                                     :access_token_path => '/oauth/access_token',
                                                     :http_method => :post
                                                   })
    @callback_url = "http://localhost:3000/settings/social-networks/tumblr"
    # @request_token = @consumer.get_request_token
    # redirect_to @request_token.authorize_url + '&' + { oauth_callback:@callback_url }.to_query
  end

  def youtube
    key = ENV['YOUTUBE_KEY']
  end

end
