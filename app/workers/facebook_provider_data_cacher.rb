class FacebookProviderDataCacher
  @queue = :facebook_provider_cache_data_queue

  def self.perform(provider_id)
    provider = Provider.find provider_id
    #if provider.facebook[:data_cached_at] < APP_CONFIG.facebook.cache_expiry_time.ago.utc
      if provider.cache_facebook_data?
        provider.facebook_data[:data_cached_at]  = Time.now.utc
        provider.save! 
      else
        # TODO add to task rescheduling list
      end
    #end
  end
end
