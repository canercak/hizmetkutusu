class ConversationBuild
  def initialize(params, user, quote )
    @params = params
    @user = user
    @quote = quote
 
  end

  def conversation 
    result = @quote.conversations.build
    result.messages.build  message 
    result.users = [@user, @quote.user] 
    result
  rescue
    # TODO
  end

  def message

    result = @params[:message] 
    result.merge! sender: @user
    # if @file.present?
    #   result[:body] = result[:body] +( " | " + @file)
    # end
    return result

  end
end
