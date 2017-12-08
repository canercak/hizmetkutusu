class PagesController < ApplicationController

  skip_before_filter :require_login

  def home 
    if logged_in? 
      if current_user.providers.present?
        redirect_to provider_path(current_user.providers.first.slug)
      else
        redirect_to new_quote_path
      end
    else
      @reviews =  Provider.all.map {|p| p.references}
      if @reviews.present?
        @reviews = @reviews[0].order_by(:'created_at'.desc)
        sum = @reviews.map{|r| r.rating}.sum.to_i 
        @reviewavarage = nil
        if sum > 0
			     @reviewavarage = (@reviews.map{|r| r.rating}.sum.to_i/@reviews.count)       
		    end
      end
      render layout: false
    end
  end

  def fbjssdk_channel
    response.headers['Pragma'] = 'public'
    response.headers['Cache-Control'] = "max-age=#{1.year.to_i}"
    response.headers['Expires'] = 1.year.from_now.httpdate
    render layout: false
  end
end
