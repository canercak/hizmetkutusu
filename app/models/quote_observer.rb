class QuoteObserver 
  def after_create(quote)
    if quote.share_on_facebook_timeline
      Resque.enqueue(FacebookTimelinePublisher, quote.id)
    end
  rescue Redis::CannotConnectError
  end
end
