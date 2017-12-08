module ConversationsHelper
  def message_classes(alternate, message, current_user)
    [('alternate' if alternate), ('unread' if message.sender != current_user && message.unread?)].join(' ')
  end

  def message_timestamp(message)
    content_tag(:small, title: I18n.l(message.created_at.in_time_zone(current_user.time_zone), format: :long), class: 'pull-right muted') do
      I18n.t('conversations.messages.time_ago', time: distance_of_time_in_words(message.created_at, Time.now.utc))
    end
  end

  def message_readat(message)
    content_tag(:small, class: 'muted') do
      content_tag(:i, nil, class: 'icon-ok') + ' ' +
      I18n.t('conversations.messages.seen', date: l(message.read_at.in_time_zone(current_user.time_zone), format: :short))
    end
  end

  def new_or_show_conversation_path(conversation)    
    conversation = Conversation.find_by(:conversable_id=>conversation.conversable_id)
    if conversation.present?
      conversation.created_at.present?  ? conversation_path(conversation) : new_conversation_path(quote_id: conversation.conversable_id)
    end
  end
end
