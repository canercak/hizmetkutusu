class ConversationsController < ApplicationController
  before_filter :require_login 
  include Transloadit::Rails::ParamsDecoder
  after_filter :mark_as_read, only: [:show]

  def index
    @conversations = current_user.conversations.includes(:users).desc(:updated_at).page params[:page]
  end

  def show
    @conversation = Conversation.find(params[:id])
    @quote = Quote.find(@conversation.conversable_id)

  end

  def new
    @quote = Quote.find(params[:quote_id])
    @conversation = current_user.conversations.build
  end

  def create
 
    @quote = Quote.find(params[:quote_id])
    @conversation = ConversationBuild.new(conversation_params, current_user, @quote).conversation
    if @conversation.save
      redirect_to quotes_path(@quote) 
    else
      flash.now[:error] = @conversation.errors.full_messages
      render :new
    end
  end

  def update
 
    @conversation = Conversation.find(params[:id])
    @quote = Quote.find(@conversation.conversable_id) 
    @conversation.messages.build ConversationBuild.new(conversation_params, current_user, @quote ).message
    if @conversation.save
      redirect_to quote_path(@quote)
    else
      flash.now[:error] = @conversation.errors.full_messages
      @conversation.reload
      @quote = Quote.find(@conversation.conversable_id)
      render :show
    end
  end

  def unread
    respond_to do |format|
      format.json do
        @conversations = current_user.conversations.includes(:users).unread(current_user).desc(:updated_at).limit(5)
      end
      format.html do
        redirect_to :conversations
      end
    end
  end

  private
  def mark_as_read
    @conversation.mark_as_read(current_user)
  end
  def conversation_params
    params.required(:conversation).permit(    
      message: [:body] )
  end
end
