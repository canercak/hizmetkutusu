module UsersHelper
#require 'json'
#require 'active_support/core_ext'
  def facebook_profile_picture(user, type = :square)
    "https://graph.facebook.com/#{user.class == User ? user.uid : user}/picture?type=#{type}"
  end  
 
  def user_transactions
    return [t('users.financialsettings.by_havale'), t('users.financialsettings.by_mobil')]
  end 

  def user_profile_picture(user, size: [50, 50], type: :square, style: 'img-polaroid', opts: {})

    image = nil
      if user.provider == "identity"
        if user.user_image.blank?
          image = asset_path("profile_pic_big.png")
        else
          image = user.user_image
        end
      elsif user.provider == "facebook"
        image = facebook_profile_picture(user, type)
      else
      end
    tag :img,
        { width: ("#{size[0]}px" if size),
          height: ("#{size[1]}px" if size),
          src: image,
          alt: 'userimage',
          class: [('verified' if user.class == User.model_name && user.facebook_verified?), style].compact.join(' ')
        }.merge(opts)
  end 

  def navbar_notifications(title, opts = {})
    options = { icon: 'globe',
                id: 'notifications',
                link: nil,
                mock: false,
                ajax: nil,
                content: nil,
                unread: 0 }.merge(opts)
    content = "\
      #{("<div id='#ajax-#{options[:id]}' class='popover-ajax-content'> \
        <div style='text-align: center'>#{image_tag 'ajax-spinner-24x17.gif', width: 24, height: 17, alt: "..."}</div>
      </div>" if options[:ajax]) || "<div class='popover-static-content'>#{options[:content]}</div>"} \
      #{"<p><small>#{options[:link]}</small></p>" if options[:link]}"
    content_tag(:li,
                class: "notifications#{(" read" if options[:unread] == 0)}#{(" mock" if options[:mock])}",
                id: "navbar-notifications-#{options[:id]}") do
      content_tag(:a,
                  content_tag(:i, nil, class: "icon-#{options[:icon]}") + (content_tag(:span, options[:unread], class: 'label label-important count') if options[:unread] > 0),
                  href: '#',
                  rel: 'popover',
                  data: { placement: 'bottom', content: content, title: title, html: true, trigger: 'manual', load: (options[:ajax]) })
    end
  end

  def friends_with_privacy(friends)
    case friends
    when 0...10
      '10-'
    when 10...100
      "#{friends/10}0+"
    when 100...1000
      "#{friends/100}00+"
    when 1000...5000
      "#{friends/1000}000+"
    else
      '5000'
    end
  end

  def mutual_friends(user1, user2, limit = 5)
    return if user1 == user2
    mutual_friends_list = user1.facebook_friends & user2.facebook_friends
    return unless mutual_friends_list.any?
    html = content_tag(:div, t('.common_friends'), class: 'tag tag-facebook')
    mutual_friends_list.sample(limit).each do |mutual_friend|
      html << render_mutual_friend(mutual_friend)
    end
    html << link_to(t('.and_others', count: mutual_friends_list.size - 5), '#', class: 'disabled tag mock') if mutual_friends_list.size - 5 > 0
    html
  end

  def check_common_field(user, field)
    'common' if user != current_user && user.send(field) == current_user.send(field)
  end

  def language_tags(user)
    return unless user.languages && user.languages.any?
    render_tags user.languages, current_user.languages, render_common_tags: (user != current_user), content: t('.likes'), class: 'description-facebook'
    common_languages = get_common_tags(current_user.languages, user.languages) if (render_common_tags = (user != current_user))
    html = user.languages.map { |language| render_tag t('.language', language: language['name']), (render_common_tags && common_languages.include?(language['id'])) }
    html.join.html_safe
  end

  def work_and_education_tags(user, field)
    return unless user[field] && user[field].any?
    user_work_or_edu = remap_work_or_edu_tags user[field]
    my_field = current_user[field]
    if (render_common_work_or_edu = (user != current_user) && my_field && my_field.any?)
      my_work_or_edu = remap_work_or_edu_tags my_field
    end
    render_tags user_work_or_edu, my_work_or_edu, render_common_tags: render_common_work_or_edu, content: User.human_attribute_name(field), class: 'tag tag-facebook'
  end

  def favorite_tags(user, user_favorites)
    return unless user_favorites && user_favorites.any?
    render_tags user_favorites, current_user.facebook_favorites, render_common_tags: (user != current_user), content: t('.likes'), class: 'tag tag-facebook'
  end
  

  def quote_tags(user)
    html = [1,2].map { |quote_type| quote_tag user, quote_type }
    html.join.html_safe
  end 
  
  def quote_tag(user, quote_type)  
    quotes_taken =user.quotes.count
    quotes_done = user.quotes.count
    if quote_type == 1
      quote_type = quotes_taken > 0 ? quotes_taken.to_s + t('users.show.taken') : t('users.show.not_taken')
    else
      quote_type =  quotes_done > 0 ? quotes_done.to_s + t('users.show.done') : t('users.show.not_done')
    end
    content_tag(:div, t("quotes.snippet.#{quote_type }", count: nil), class: 'tag')
  end


  private
  def remap_work_or_edu_tags(field) 
    if field[0]["employer"].present?
      field.map {|el| el["employer"] } 
    else
      field.map {|el| el["school"] }
    end
  end

  def get_common_tags(my_tags, user_tags)
    return [] if my_tags.nil? || my_tags.empty?
    my_tags.map { |tag| tag['id'] } & user_tags.map { |tag| tag['id'] }
  end

  def render_mutual_friend(mutual_friend)
    content_tag(:div, class: 'tag tag-mutual-friend') do
      user_profile_picture(mutual_friend['id'], size: [25,25], style: nil) +
      mutual_friend['name']
    end
  end

  def render_tag(tag_text, common)

    content_tag :div, tag_text, class: ("tag#{' common' if common}")
  end

  def render_tags(user_tags, my_tags, opts = {})

    options = { render_common_tags: false }.merge(opts)
    common_tags = get_common_tags(my_tags, user_tags) if options[:render_common_tags]
    html = content_tag(:div, options[:content], class: options[:class])
    user_tags.each do |tag|
      html << render_tag(tag['name'], options[:render_common_tags] && common_tags.include?(tag['id']))
    end
    html
  end
  
  
  def friends_in_system
    #@arr = current_user.facebook_friends
    #return @friends_in_system = User.where(:_id.in => @arr) 
  end
  
  
  def provider_owner(id)
    if current_user.present? && current_user.providers.find_by(id: id)
      return true
    else
      return false  
    end
  end
 
end
