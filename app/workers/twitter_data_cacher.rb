class TwitterDataCacher
  @queue = :twitter_cache_data_queue

  def self.perform(provider_id)
    require "twitter"
       twitter = Twitter::REST::Client.new do |config|
        config.consumer_key        = "E7IBAH1vdLR3mG4V0M3uIh4Dm"
        config.consumer_secret     = "uFEPEwyb6wJTQ3X8qDedx1SY4lp3yCZpTQHo9PW2VcnlavTBKY"
        config.access_token        = "1620451722-GFyRLUqlXsY1FhDojeM5D5ZAeCgMx9FAgCv2S2B"
        config.access_token_secret = "4QXs408JRBpr2GAKU1tliBfgBudG2OeNclgKdiUdLTW1j"
      end
    provider = Provider.find provider_id
    #if provider.instagram[:data_cached_at] < APP_CONFIG.instagram.cache_expiry_time.ago.utc

      if provider.cache_twitter_data(twitter) == true
        provider.twitter_data[:data_cached_at]  = Time.now.utc
        provider.save! 
      else
        # TODO add to task rescheduling list
      end
    #end
  end
end
