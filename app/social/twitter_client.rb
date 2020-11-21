class TwitterClient <Twitter::REST::Client

  def initialize
    super do |config|
      config.consumer_key        = PropertsHelper::TWITTER_KEY
      config.consumer_secret     = PropertsHelper::TWITTER_KEY_SECRET
      config.access_token        = PropertsHelper::TWITTER_TOKEN
      config.access_token_secret = PropertsHelper::TWITTER_TOKEN_SECRET
    end
  end



end