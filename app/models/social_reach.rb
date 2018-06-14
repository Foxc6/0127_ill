class SocialReach < ActiveRecord::Base
  belongs_to :contact
  belongs_to :social_network
  after_create :update_social_reach

  def name
  	self.social_network.name
  end

  def url
  	if self.social_network.name.downcase == 'tumblr'
  		tmp = self.social_network.url
  		tmp = tmp.gsub('www', self.username)
  	else
  		"#{self.social_network.url}/#{self.username}"
  	end
  end

  private

  def twitter_call
    @twitter_client = Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV['TWITTER_CONSUMER_KEY']
      config.consumer_secret     = ENV['TWITTER_CONSUMER_SECRET']
      config.access_token        = ENV['TWITTER_ACCESS_TOKEN']
      config.access_token_secret = ENV['TWITTER_TOKEN_SECRET']
    end
    return @twitter_client
  end

  def update_twitter_reach
    reach_test = SocialReach.where(social_network_id: twitter_id).where(contact_id: self.contact_id).first
    if reach_test.nil?
      twitter_id = SocialNetwork.where({name:'Twitter'}).first.id
      twitter_reaches = Contact.joins(:social_reaches).where(social_reaches: {social_network_id:twitter_id})
      client = twitter_call
      if client.nil?
      else
        reach = SocialReach.new
        reach.total_reach = client.followers("#{self.username}").count
        reach.username = self.username
        reach.social_network_id = twitter_id
        reach.contact_id = self.contact_id
        reach.save
      end
    end
  end

  def update_facebook_reach
  end

  def update_pinterest_reach
  end

  def update_instagram_reach


  end

  def update_tumblr_reach
    key = ENV['TUMBLR_KEY']
    secret = ENV['TUMBLR_SECRET']
    site = "http://www.tumblr.com"

    # puts 'Setting up request'
    @consumer = OAuth::Consumer.new(key, secret, { :site => site,
                                                     :request_token_path => '/oauth/request_token',
                                                     :authorize_path => '/oauth/authorize',
                                                     :access_token_path => '/oauth/access_token',
                                                     :http_method => :post
                                                   })
    @request_token = @consumer.get_request_token(:oauth_callback => "http://localhost:3000/settings/social-networks/tumblr")
    Tumblr.configure do |config|
      config.consumer_key = ENV['TUMBLR_KEY']
      config.consumer_secret = ENV['TUMBLR_SECRET']
      config.oauth_token = @oauth_token
      config.oauth_token_secret = @oauth_token_secret
    end
  end

  def update_youtube_reach
  end

  def update_social_reach
    network = SocialNetwork.find_by_id(self.social_network_id)
    network_name = network.name
    case network_name
    when "Facebook"
      update_facebook_reach
    when "Twitter"
      update_twitter_reach
    when "Pinterest"
      update_pinterest_reach
    when "Instagram"
      update_instagram_reach
    when "Tumblr"
      update_tumblr_reach
    when "YouTube"
      update_youtube_reach
    else
      puts "Network Not Found"
    end
  end

end
