
module QuotesHelper

  def boolean_options_for_select
    @boolean_options_for_select ||= options_for_select [[t('boolean.true'), true], [t('boolean.false'), false]]
  end
 
  def default_leave_date
    @default_leave_date ||= ((Time.now).change(min: (Time.now.min / 10) * 10) + 10.minutes).in_time_zone
  end

  def get_cookie_address(cookies)
    address = Hash.new
    if cookies[:geolocation].present? 
      lat_lng = cookies[:geolocation].split("|")
      address[:location] = [lat_lng[1].to_f, lat_lng[0].to_f]
      address[:address] = Geocoder.address("#{address[:location][1]},#{address[:location][0]}").to_s
    elsif cookies[:geolocation].blank? && cookies[:iplcation].present? 
      lat_lng = cookies[:iplcation].split("|")
      address[:location] = [lat_lng[1].to_f, lat_lng[0].to_f]
      address[:address]  = Geocoder.address("#{address[:location][1]},#{address[:location][0]}").to_s
    else
      address[:location]= [32.85410999999999,39.92077] #ankara
      address[:address] = "Ankara" 
    end
    return address
  end

  def get_quote_providers(quote)
    Quote.includes(:provider).find(quote._id).provider.officialname
  end

  def get_quote_status(quote)
    result= nil
    reservation = quote.provider.reservations.where(:quote_id=>quote._id).to_a.first
    if reservation.status == 1
      result = t('quotes.selected_providers.applied')   
    elsif reservation.status == 2
      result = t('quotes.selected_providers.reservation_cancelled')
    else
      result = t('quotes.selected_providers.reservation_made') 
    end 
    return result
  end 

  def boolean_tag(value, field)
    status = value ? 'allowed' : 'forbidden'
    content_tag :span, t(".#{field}.#{status}"), class: "tag tag-#{status}"
  end
  
  def user_provider_phones
   phones = current_user.providers.map {|p| p.business_phone}
   phones << [t('helpers.links.add_new'), 0]    
  end
  
  def get_quote_reference(quote)
      if quote.provider.references.present?
        ref = provider.references.find_by(:quote_id =>quote.id)
        reference = [ref.rating, ref.comment] unless ref.present?
      end
  
    return reference 
  end
  

  def find_category(category_id)
    @category =Category.find(category_id)  
    category_fullname = @category.parent + ' - '+@category.title 
    return category_fullname
  end 
  
  def share_on_facebook_timeline_checkbutton(form)
 
    has_publish_stream_permission = current_user.has_facebook_permission?(:publish_stream)
    if background_jobs_available?
      (form.label :share_on_facebook_timeline, class: "btn btn-facebook btn-small btn-checkbox#{' disabled' unless has_publish_stream_permission}" do
        form.default_tag(:check_box, :share_on_facebook_timeline, disabled: !has_publish_stream_permission, checked: has_publish_stream_permission) +
        content_tag(:i, nil, class: 'icon-check-empty check') + ' ' +
        t('helpers.links.share_on_facebook_timeline')
      end) +
      (unless has_publish_stream_permission
        content_tag(:p, class: 'muted') do
          content_tag(:small) do
            content_tag(:i, nil, class: 'icon-ban-circle') + ' ' +
            t('.missing_publish_stream_permission', appname: APP_CONFIG.app_name)
          end
        end
      end)
    else
      t('.share_on_timeline_unavailable', appname: APP_CONFIG.app_name)
    end
  end
  
  
  def list_selected_providers(quote)
    provider = Provider.where(:_id.in=>quote.provider_ids) 
    content_tag(:span) do
      provider.each do |provider|
        if provider.id == quote.providerdone 
            concat content_tag(:div,          
            image_tag(provider.provider_image.thumb.url, :alt => '', height: "60", width: "60") +
            content_tag(:div,
            content_tag(:div,              
            content_tag(:a, provider.officialname, :href=> '/providers/'+provider.id) + 
            content_tag(:p,'Hizmet Verdi', :class => "label label-info"),
            :class => "h4 media-heading") ,
            :class => "media-body") ,
            :class => "span3") 
        end
      end
    end
  end
 
end
 
