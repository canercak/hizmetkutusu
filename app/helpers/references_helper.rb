
module ReferencesHelper
  def make_thumbs(rating)
    case rating
    when -1 then content_tag :i, nil, class: 'icon-thumbs-down'
    when 1 then content_tag :i, nil, class: 'icon-thumbs-up'
    end
  end
   
   
   
  def reference_tags(user)
    html = [t('users.show.comments')].map { |reference_type| reference_tag user, reference_type }
    html.join.html_safe
  end 
  
  def get_star_rating(rating)
    total = rating.servicerating.to_i +  rating.pricerating.to_i +  rating.speedrating.to_i 
    rating = nil
    if total == 3 
      rating = 5
    elsif total == 1
      rating = 4
    elsif total == -1 
      rating = 2
    else
      rating = 1
    end
    return rating
  end
  private
  def reference_tag(user, reference_type) 
    providerdones = current_user.quotes.map{|quote| quote.providerdone}
    providers = Provider.all.where(:_id.in =>providerdones).to_a
    references = providers.map {|p| p.references}
    if references[0].present?
      sv = references.map{|ref| ref[0].comment}.count 
    end
    if reference_type == t('users.show.comments') && references[0].present?
      reference_type = sv.to_s+ " "  + t('users.show.comment_given') 
    else
      reference_type =   t('users.show.comment_not_given')
    end
      
    content_tag(:div, t("references.snippet.#{reference_type }", count: nil), class: 'tag')
  end
  
  def reference_array
    ["E E E" , "E E H" , "E H H" , "H H H" ,"H H H" ,"H H E" , "H E E" ,"E H E" ,"H E H", "EVET EVET EVET" , "EVET EVET HAYIR" , "EVET HAYIR HAYIR" , "HAYIR HAYIR HAYIR" ,"HAYIR HAYIR HAYIR" ,"HAYIR HAYIR EVET" , "HAYIR EVET EVET" ,"EVET HAYIR EVET" ,"HAYIR EVET HAYIR"]
  end
 
    
end
