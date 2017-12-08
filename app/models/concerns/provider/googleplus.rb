module Concerns
  module Provider
    module Googleplus
      extend ActiveSupport::Concern
      included do
        def googleplus
          begin
            GooglePlus.api_key = "AIzaSyB9-y-Li2AblLD8k_EwO8oGXIXtTqvnNQ4"
            @googleplus ||= GooglePlus::Person
            block_given? ? yield(@googleplus) : @googleplus
          rescue  => e
            logger.info e.to_s
            nil
          end 
        end
  

        def cache_googleplus_data?
          begin
            googleplus do |gp|
              result = gp.get(self.googleplus_data[:uri].split("/").last).attributes
              if result.any?
                self.googleplus_data[:image] = result["image"].present? ? result["image"]["url"] : ""
                self.googleplus_data[:cover_image] = result["cover"].present? ? result["cover"]["coverPhoto"]["url"] : ""
                self.googleplus_data[:plus_one_count] = result["plus_one_count"]
                self.googleplus_data[:circled_by_count] = result["circled_by_count"]
                self.save!
                return true
              else
                false 
              end
            end
          rescue => e 
            logger.warn "error googleplus fetcher: #{e}" 
          end
        end

        module ClassMethods
        end

      end
    end
  end
end
