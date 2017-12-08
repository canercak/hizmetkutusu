class MessagesController < ApplicationController
  before_filter :require_login 
  def create
    conversation = current_user.conversations.find(params[:conversation_id])
    if conversation.messages.create(params[:message].merge(sender: current_user))
      #redirect_to conversation_path(conversation)
      quote= Quote.find(conversation.conversable_id)
      redirect_to quote_path(quote)
    else
      #redirect_to conversation_path(conversation), flash: { error: t('flash.messages.error.create') }
      redirect_to quote_path(@quote)
    end
  end
end
