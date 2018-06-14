require "cgi"
require "base64"
namespace :social do
  desc 'Update Twitter follower count'
  task :update_twitter => :environment do

    twitter_url = "https://api.twitter.com/1.1/users/show.json?screen_name=twitterdev"
    api_key = ENV['TWITTER_CONSUMER_KEY']
    # api_key = CGI.escape(api_key)
    api_secret = ENV['TWITTER_CONSUMER_SECRET']
    # api_secret = CGI.escape(api_secret)
    access_token = ENV['TWITTER_ACCESS_TOKEN']
    access_token_secret = ENV['TWITTER_TOKEN_SECRET']
    bearer_token_credentials = api_key + ":" + api_secret
    bearer_token_credentials = Base64.encode64(bearer_token_credentials)
    @response = HTTParty.post('https://api.twitter.com/oauth2/token',
                  :query => {
                      'grant_type' => 'client_credentials'
                    },
                  :headers => {
                      'Host' => 'api.twitter.com',
                      'Content_Type' => 'application/x-www-form-urlencoded;charset=UTF-8',
                      'User_Agent' => 'origins-influencers',
                      'Content_Length' => '29',
                      'Accept_Encoding' => 'gzip',
                      'Authorization' =>  "#{bearer_token_credentials}"
                  }
                )
    access_token = @response["access_token"]

    # uri = URI.parse("httpsre://api.twitter.com/")
    # http = Net::HTTP.new(uri.host, uri.port)
    # http.use_ssl = true
    # http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    # request = Net::HTTP::Post.new("/oauth2/token")
    # request.add_field('grant_type', 'client_credentials')
    # request.body = {
    #   'authorization' => {
    #     'Basic' => 'bearer_token_credentials',
    #     'Content-Type' => 'application/x-www-form-urlencoded;charset=UTF-8'
    #   }
    # }.to_query
    # response = http.request(request)

    twitter_id = SocialNetwork.where({name:'Twitter'}).first.id

    influencers = Contact.joins(:social_reaches).where(social_reaches: {social_network_id:twitter_id})
    reach = []
    #iterate through all influencers
    influencers.each do |influencer|
      if influencer.twitter.present?
        screen_name = influencer.twitter.username
        response = HTTParty.get('https://api.twitter.com/1.1/users/show.json',
                    :query => {:screen_name => screen_name},
                    # :header => {
                    #   :oauth_consumer_key => ,
                    #   :oauth_nonce => ,
                    #   :oauth_signature => ,
                    #   :oauth_signature_method => "HMAC-SHA1",
                    #   :oauth_token => ,
                    #   :oauth_version => "1.0"
                    # }
                  )

          if response.present? && response.name.present?
          reach.push({
            :name => response.name,
            :followers_count => response.followers_count
          })
        end
    end
  end
end

  desc 'Update Facebook follower count'
  task :update_facebook => :environment do
    puts 'Update Facebook'
  end

  desc 'Update Pinterest follower count'
  task :update_pinterest => :environment do
    puts 'Update Pinterest'
  end

  desc 'Update Instagram follower count'
  task :update_instagram => :environment do
    puts 'Update Instagram'
  end

  desc 'Update Tumblr follower count'
  task :update_tumblr => :environment do
    puts 'Update Tumblr'
  end
end
