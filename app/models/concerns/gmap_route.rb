module Concerns
  module GmapRoute
    extend ActiveSupport::Concern

    included do
      include Mongoid::Geospatial
      include UsersHelper

      field :latitude
      field :longitude
      field :provider_ids
      field :user_id
 

      def route=(param)
 
        json_route = JSON.parse param
        self.latitude    = json_route['latitude']
        self.longitude      = json_route['longitude']
        self.provider_ids   = json_route['provider_ids']
        self.user_id   = json_route['user_id']
      rescue
      end

      def static_map(width = 440, height = 220)
        provider = self.provider
        user_location = location[1].to_s + ',' + location[0].to_s
        user_icon = URI.encode("https://graph.facebook.com/#{self.user.uid}/picture?width=24&height=24" )
        provider0 = provider.location.first.to_s + ',' +provider.location.second.to_s 
        provider0_icon =URI.encode(provider.provider_images["provider_image1"][2])
        return URI.encode("https://maps.google.com/maps/api/staticmap?center=#{user_location}&zoom=9&size=#{width}x#{height}&scale=2&sensor=false&visual_refresh=true&markers=icon:#{provider0_icon}|size:10x10|#{provider0}&markers=icon:#{user_icon}|size:10x10|#{user_location}")
       end 
     end
  end
end
