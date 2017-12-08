module ProvidersHelper
include ActionView::Helpers::DateHelper
require 'action_view'


  def business_type_options
    [[t("shared.navbar.company_no"), 0], 
    [t("shared.navbar.company_personal"), 1],  
    [t("shared.navbar.company_limited"), 2],
    [t("shared.navbar.company_anonymous"), 3]] 
  end

  def province_list
    address = Address.where(:parent=>nil)
    return address.to_a.map {|a| a.title} 
  end 
 
  def calculate_counts(v1, v2)
    if v1.present? && v2.present?
      v1 + v2
    elsif v1.blank? && v2.present?
      v2
    elsif v1.present? && v2.blank?
      v1
    else
      nil
    end      
  end

  def compose_address(decomposed_address)
      decomposed_address[:local] + ", " +
      decomposed_address[:street] + ", " + 
      (decomposed_address[:no_door].present? ? (decomposed_address[:no_door] + ", ") : "") + 
      decomposed_address[:postcode] + ", " +
      decomposed_address[:district] + "/" +
      decomposed_address[:province] 
  end

  def social_media_types
    ["foursquare", "facebook","twitter", "googleplus", "instagram" ]
  end

  def get_title(variation_id)
  category = Category.find_categories(variation_id).to_a[0]
  return category.ancestors[1]+ "/" + category.ancestors[2] + "/" + category.title
  end
   
  def show_business_type(type)
    business_type_options[type][0]
  end

  def selected_variations(categories)
   all_variations = categories["children"].map{|c| c["children"].map{|c| c["children"].map{|c| c["children"]}}}.reduce(:+).reduce(:+).compact.reduce(:+)
   selected_variations = all_variations.map{|c| Moped::BSON::ObjectId.from_string(c["key"]) if c["selected"] == true}.compact 
   return selected_variations
  end
  
  
  def calendar_range(provider)
 
    start_t = provider.business_hours.select{|x| x["isActive"] == true}.min_by{|x| x["timeFrom"]}["timeFrom"].to_i
    end_t  = provider.business_hours.select{|x| x["isActive"] == true}.max_by{|x| x["timeTill"]}["timeTill"].to_i
    return [start_t, end_t]
  end 
 


  def convert_business_hour(hour)
    if hour.include?(":30")
      return hour.to_f + 0.5
    else
      return hour.to_f
    end  
  end


  def calendar_blocked_times(provider) 
 
    range = calendar_range(provider)
    min_hour = provider.business_hours.select{|x| x["isActive"] == true}.min_by{|x| x["timeFrom"]}["timeFrom"].to_i
    max_hour = provider.business_hours.select{|x| x["isActive"] == true}.max_by{|x| x["timeTill"]}["timeTill"].to_i
    blocked_array = []
    block1 = []
    block2 = []
    provider.business_hours.each do |bh, index| 
       unless bh["isActive"] == false
        from =  convert_business_hour(bh["timeFrom"])
        till =  convert_business_hour(bh["timeTill"])

        if from > min_hour
          block1 = [min_hour,from]
        end
        if till < max_hour
          block2 = [till, max_hour]
        end
        if block1.present? && block2.present?
          blocked_array <<  [block1[0],block1[1],block2[0],block2[1]]
        elsif block1.present? && block2.blank?
          blocked_array <<  [block1[0],block1[1]]
        elsif block2.present? && block1.blank?
          blocked_array <<  [block2[0],block2[1]]
        else
          blocked_array << "open"
        end
      else
        blocked_array << "close"
      end
    end

    return blocked_array 
  end
  
  
  def boolean_tag(value, field)
    status = value ? 'allowed' : 'forbidden'
    content_tag :span, t(".#{field}.#{status}"), class: "tag tag-#{status}"
  end
  
  def user_view?
    true
  end  
  
  
  def transloadit_provider_images(params, images) 
    if params.blank?
      return nil
    end
    if (params[:results][:resizebig].blank? || params[:results][:resize].blank?)
      return nil
    end
    if images == nil 
      images= Hash.new {|h,k| h[k]=[]}   
    end
    params[:results][:resize].each do |resize|     
      if resize[:field].include? "provider_image1"
        images[:provider_image1] = []
         images[:provider_image1] << resize[:ssl_url]
      elsif resize[:field].include? "provider_image2"
        images[:provider_image2] = []
        images[:provider_image2] << resize[:ssl_url]
      elsif resize[:field].include? "provider_image3"
        images[:provider_image3] =[]
        images[:provider_image3] << resize[:ssl_url]
      elsif resize[:field].include? "provider_image4"
        images[:provider_image4] = []
        images[:provider_image4] << resize[:ssl_url]
      elsif resize[:field].include? "provider_image5"
        images[:provider_image5] = []
        images[:provider_image5] << resize[:ssl_url]
      elsif resize[:field].include? "provider_image6"
        images[:provider_image6] = []
        images[:provider_image6] << resize[:ssl_url]
      elsif resize[:field].include? "certificate_image1"
        images[:certificate_image1] = []
        images[:certificate_image1] << resize[:ssl_url]
      elsif resize[:field].include? "certificate_image2"
        images[:certificate_image2] = []
        images[:certificate_image2] << resize[:ssl_url]
      elsif resize[:field].include? "certificate_image3"
        images[:certificate_image3] = []
        images[:certificate_image3] << resize[:ssl_url]
      elsif resize[:field].include? "certificate_image4"
        images[:certificate_image4] = []
        images[:certificate_image4] << resize[:ssl_url] 
      else
      end
    end
    params[:results][:resizebig].each do |upload|    
      if upload[:field].include? "provider_image1"
        images[:provider_image1] << upload[:ssl_url]
      elsif upload[:field].include? "provider_image2"
        images[:provider_image2] << upload[:ssl_url]
      elsif upload[:field].include? "provider_image3"
        images[:provider_image3] << upload[:ssl_url]
      elsif upload[:field].include? "provider_image4"
        images[:provider_image4] << upload[:ssl_url] 
      elsif upload[:field].include? "provider_image5"
        images[:provider_image5] << upload[:ssl_url]
      elsif upload[:field].include? "provider_image6"
        images[:provider_image6] << upload[:ssl_url] 
      elsif upload[:field].include? "certificate_image1"
        images[:certificate_image1] << upload[:ssl_url]
      elsif upload[:field].include? "certificate_image2"
        images[:certificate_image2] << upload[:ssl_url]
      elsif upload[:field].include? "certificate_image3"
        images[:certificate_image3] << upload[:ssl_url]
      elsif upload[:field].include? "certificate_image4"
        images[:certificate_image4] << upload[:ssl_url]
      else
      end
    end 
    if params[:results][:resizemini][0]["field"].include? "provider_image1"
      images[:provider_image1] << params[:results][:resizemini][0]["ssl_url"]
    end 
    return images 
  end 

  def initial_business_hours
  "[{\"isActive\":true,\"timeFrom\":\"9:00\",\"timeTill\":\"18:00\"},{\"isActive\":true,\"timeFrom\":\"9:00\",\"timeTill\":\"18:00\"},{\"isActive\":true,\"timeFrom\":\"9:00\",\"timeTill\":\"18:00\"},{\"isActive\":true,\"timeFrom\":\"9:00\",\"timeTill\":\"18:00\"},{\"isActive\":true,\"timeFrom\":\"9:00\",\"timeTill\":\"18:00\"},{\"isActive\":false,\"timeFrom\":null,\"timeTill\":null},{\"isActive\":false,\"timeFrom\":null,\"timeTill\":null}]"
  end


  def calculate_price(provider, price_ids) 
    prices = provider.workdones.map{|w| w.prices.map { |p| p.price if (price_ids.include? p._id)}.compact}#.reject! { |c| c.empty? }
    return prices.inject {|sum, x| sum +x }.inject {|sum, x| sum +x } 
  end

  def calculate_score(rating) 
    value = 0
    if rating == 1
      value = -10
    elsif rating == 2
      value = -5
    elsif rating == 3
      value = 5
    elsif rating == 4
      value = 10
    elsif rating == 5
      value = 15
    else
      value = 0
    end
    return value
       
  end
  
 
  
end
   
