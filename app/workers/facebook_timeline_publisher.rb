class FacebookTimelinePublisher
  @queue = :facebook_timeline_queue

  def self.perform(quote_id)
    quote = Quote.find quote_id
    quote_url = Rails.application.routes.url_helpers.quote_url quote, host: APP_CONFIG.base_url
    user = quote.user
    return unless user.has_facebook_permission?(:publish_stream)
    user.facebook do |fb|
      if APP_CONFIG.facebook.restricted_group_id
        fb.put_wall_post quote.title,
                         { name: quote.title, link: quote_url },
                         APP_CONFIG.facebook.restricted_group_id
      else
        fb.put_connections 'me', "#{APP_CONFIG.facebook.namespace}:plan", quote: quote_url
      end
    end
  end
end
