module Concerns
  module Provider
    module Twitter
      extend ActiveSupport::Concern
      included do 
        def cache_twitter_data(twitter)
          begin  
            uri = self.twitter_data[:uri].split("/")
            result = twitter.user("#{uri.last.parameterize}") 
            if result.present? 
              self.twitter_data[:followers_count] = result.followers_count
              self.twitter_data[:description] = result.description
              self.twitter_data[:background_image] = result.profile_background_image_url_https 
              self.twitter_data[:profile_image] = result.profile_image_url_https.scheme + "://" + result.profile_image_url_https.host + result.profile_image_url_https.path
              self.save!
              return true
            else
              return false 
            end
 
          rescue => e 
            logger.warn "Unable to foo, will ignore: #{e}" 
          end
        end

        module ClassMethods
        end

      end
    end
  end
end
