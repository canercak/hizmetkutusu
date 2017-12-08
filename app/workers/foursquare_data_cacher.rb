class FoursquareDataCacher
  @queue = :foursquare_cache_data_queue

  def self.perform(provider_id)
    provider = Provider.find provider_id
    #if provider.foursquare[:data_cached_at] < APP_CONFIG.foursquare.cache_expiry_time.ago.utc
      if provider.cache_foursquare_data?
        provider.foursquare_data[:data_cached_at]  = Time.now.utc
        provider.save! 
      else
        # TODO add to task rescheduling list
      end
    #end
  end
end
