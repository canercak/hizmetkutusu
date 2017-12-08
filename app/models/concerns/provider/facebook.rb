module Concerns
  module Provider
    module Facebook
      extend ActiveSupport::Concern
      included do
        def facebook
          begin
            @facebook ||= Koala::Facebook::API.new
            block_given? ? yield(@facebook) : @facebook
          
          rescue Koala::Facebook::APIError => e
            logger.info e.to_s
            nil
          end 
        end

        def update_facebook_data(result,fc_id)
          self.facebook_data[:id] = result["id"]
          self.facebook_data[:about] = result["about"]
          self.facebook_data[:description] = result["description"]
          self.facebook_data[:hours] = result["hours"]
          self.facebook_data[:location] = result["location"]
          self.facebook_data[:checkins] = result["checkins"]
          self.facebook_data[:likes] = result["likes"]
          self.facebook_data[:phone] = result["phone"]
          self.facebook_data[:picture] = facebook.get_picture("#{fc_id.last.parameterize}")
          self.facebook_data[:cover] = result["cover"].present? ? result["cover"]["source"] : ""
          self.save!
        end
 
        def cache_facebook_data?
          begin
            facebook do |fc|
              uri = self.facebook_data[:uri].split("/")
              result = fc.get_object("#{uri.last.parameterize}")
              if result.any?
                self.facebook_data[:id] = result["id"]
                self.facebook_data[:about] = result["about"]
                self.facebook_data[:description] = result["description"]
                self.facebook_data[:hours] = result["hours"]
                self.facebook_data[:location] = result["location"]
                self.facebook_data[:checkins] = result["checkins"]
                self.facebook_data[:likes] = result["likes"]
                self.facebook_data[:phone] = result["phone"]
                self.facebook_data[:picture] = fc.get_picture("#{uri.last.parameterize}")
                self.facebook_data[:cover] = result["cover"].present? ? result["cover"]["source"] : ""
                self.save!
                return true
              else
                false 
              end
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
