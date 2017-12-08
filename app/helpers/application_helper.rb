module ApplicationHelper
  def payment_array
   [t('users.financialsettings.credit_card_purchase'), t('users.financialsettings.credit_card_refund'),
    t('users.financialsettings.bank_transfer_purchase'), t('users.financialsettings.bank_transfer_refund'),
    t('users.financialsettings.mobile_transfer_purchase'), t('users.financialsettings.mobile_transfer_refund')]
  end

  def reservation_types
    [[t("shared.navbar.new_event"), 0], 
    [t("shared.navbar.done_event"), 1],
   [t("shared.navbar.cancel_event"), 2] ] 
   end

  def person_types
    [[t("shared.navbar.customer"), 0], 
    [t("shared.navbar.staff_member"), 1]] 
  end
 
  def clear_quote_session
    session[:variation_id] = nil
    session[:variation_text] = nil
    session[:location] = nil
    session[:query_date] = nil  
    session[:distance] =nil
    session[:customer_address] =nil
  end 
 
  def title(page_title)
    content_for(:title) { page_title.to_s }
  end

  def remove_after(str, stopchar)
    str.sub /#{stopchar}.+/, stopchar
  end
 
  def get_first_name(string)
    name_parts = string.split
    if name_parts.count == 1
      return name_parts[0]
    else
      return name_parts[0] + " " + name_parts[1].first.to_s + "."
    end
  end

  def remove_trailing(x)
    Float(x)
    i, f = x.to_i, x.to_f
    i == f ? i : f
    rescue ArgumentError
    x
  end
  
  def verified(providerid)
   @provider = Provider.find providerid
   if @provider.verified == true
      return true
   else
      return false
   end
  end
  
  def validate_phone(phone)
    clean_string = phone.gsub(/[() ]/, "") #.gsub(/^./, "")
    if clean_string.length == 11
      return clean_string
    else
      return nil
    end
  end 

  def yield_or_default(section, default = '')
    content_for?(section) ? content_for(section) + (" | #{APP_CONFIG.app_name}" unless (logged_in? || content_for(section) == APP_CONFIG.app_name)) : default
  end

  def twitterized_type(type)
    case type
    when :alert then 'warning'
    when :notice then 'info'
    else type.to_s
    end
  end

  def transparent_gif_image_data
    'data:image/gif;base64,R0lGODlhAQABAIAAAP///wAAACH5BAEAAAAALAAAAAABAAEAAAICRAEAOw=='
  end

  def bootstrap_form_for(object, options = {}, &block)
    options[:builder] = BootstrapFormBuilder
    form_for(object, options, &block)
  end

  def options_for_array_collection(model, attr_name, *args)
    options_for_select("#{model}::#{attr_name.to_s.upcase}".safe_constantize.map { |e| [ model.human_attribute_name("#{attr_name}_#{e}"), e] }, *args)
  end

  def background_jobs_available?
    Resque.workers.any?
  rescue
    false
  end  

  def business_hour_from_wday(wday)
    return (wday == 0 ? 6 : wday-1)
  end
   
end
