class InstagramDataCacher
  @queue = :instagram_cache_data_queue

  def self.perform(provider_id)
    require "instagram"
    #url_to_run_on_browser = "https://instagram.com/oauth/authorize/?client_id=ebe3269bd88f469eba648f598631c023&redirect_uri=https://www.hizmetkutusu.com/auth/instagram&response_type=token"
    instagram = Instagram.configure do |config|
      config.client_id = "ebe3269bd88f469eba648f598631c023"
      config.client_secret = "5c25b6acd69e4da69cf383949b963394"
    end
    provider = Provider.find provider_id
    client =Instagram.client(:access_token=>"1521291021.ebe3269.4c395c9989b0448787d1dea6a8229d3e")
    uri = provider.instagram_data[:uri].split("/") 
    user  = client.user_search("#{uri.last.parameterize}").first
    followed = Instagram.user(user[:id])[:counts][:followed_by]
    media = Instagram.user_recent_media(user[:id]).map {|a| a[:images][:standard_resolution][:url] }

    #if provider.instagram[:data_cached_at] < APP_CONFIG.instagram.cache_expiry_time.ago.utc
      if provider.cache_instagram_data(client, user, followed, media) == true
        provider.instagram_data[:data_cached_at]  = Time.now.utc
        provider.save! 
      else
        # TODO add to task rescheduling list
      end
    #end
  end
end
