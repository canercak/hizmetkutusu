module Concerns
  module Provider
    module Instagram

      extend ActiveSupport::Concern
      included do
        def cache_instagram_data(client,user, followed, media)
          begin 
            if client.present?
              self.instagram_data[:followed_by] = followed
              self.instagram_data[:profile_picture] = user[:profile_picture]
              self.instagram_data[:id] = user[:id]
              self.instagram_data[:full_name] = user[:full_name]
              self.instagram_data[:bio] = user[:bio]
              self.instagram_data[:website] = user[:website]
              self.instagram_data[:recent_media] = media
              self.save!
              return true
            else
              false 
            end 
          rescue => e 
            logger.warn "error instagram fetcher: #{e}" 
          end
        end

        module ClassMethods
        end

      end
    end
  end
end
