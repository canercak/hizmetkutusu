class GoogleplusDataCacher
  @queue = :googleplus_cache_data_queue

  def self.perform(provider_id)
    provider = Provider.find provider_id
    #if provider.googleplus[:data_cached_at] < APP_CONFIG.googleplus.cache_expiry_time.ago.utc
      if provider.cache_googleplus_data?
        provider.googleplus_data[:data_cached_at]  = Time.now.utc
        provider.save! 
      else
        # TODO add to task rescheduling list
      end
    #end
  end
end
