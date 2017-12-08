class TransactionsController < ApplicationController

  # helper_method :spreedly
  # rescue_from Spreedly::Error, with: :handle_spreedly_error
  # before_filter :require_login 
  # def transaction
  #   @credit_card = CreditCard.new
  # end

  # def transparent_redirect_complete
  #   return if error_saving_card

  #   @credit_card = CreditCard.new(spreedly.find_payment_method(params[:token]))
  #   return render_transaction unless @credit_card.valid?

  #   transaction = spreedly.purchase_on_gateway(gateway_token, params[:token], amount_to_charge, email: current_user.email, ip: request.remote_ip)
  #   if transaction.succeeded?
  #     @stored_transaction = Transaction.new
  #     @stored_transaction.payment_method_token = params[:token]
  #     @stored_transaction.transaction_token = transaction.token
  #     @stored_transaction.amount = transaction.amount
  #     @stored_transaction.type = 1
  #     @stored_transaction.user_id = current_user.id
  #     @stored_transaction.save  
  #     ammount = current_user.credits + @credit_card.how_many.to_i
  #     current_user.update_attributes(credits: ammount)
  #     return redirect_to(successful_transaction_url)
  #   else
  #     return render_unable_to_process(transaction)
  #   end       
  #   #flash.now[:error] = @user.errors.full_messages 
  # end
  
  # def refund_transaction
  #   user = User.find params[:id]
  #   transaction = spreedly.refund_transaction(params[:token])
  #   if transaction.succeeded?
  #     @stored_transaction = Transaction.new
  #     @stored_transaction.transaction_token = transaction.token
  #     @stored_transaction.amount = transaction.amount
  #     @stored_transaction.type = 2
  #     @stored_transaction.user_id = user.id
  #     @stored_transaction.done_by = current_user.id
  #     @stored_transaction.save  
  #     ammount = user.credits - transaction.amount.to_i
  #     user.update_attributes(credits: ammount)
  #     return redirect_to(refunds_admin_user_path(user.id))
  #   else
  #     return render_unable_to_process(transaction)
  #   end 
  # end
   
  # def successful_purchase
  # end


  # private
  # def error_saving_card
  #   return false if params[:error].blank?

  #   flash.now[:error] = params[:error]
  #   render_transaction
  #   true
  # end

  # def render_transaction
  #   @credit_card = CreditCard.new unless @credit_card
  #   render(:action => :transaction)
  # end

  # def spreedly
  #   @spreedly ||= Spreedly::Environment.new(APP_CONFIG.spreedly.env_key, APP_CONFIG.spreedly.env_secret, currency_code: 'USD', base_url: APP_CONFIG.spreedly.env_domain)
  # end
  
  # def retrieve_transactions
  #   usertransaction = Transaction.where(:user_id => current_user.id).last
  #   transactions = @spreedly.list_transactions(nil, usertransaction.token)
  # end  

  # def amount_to_charge
  #   (( @credit_card.how_many.to_i ) * 100).to_i
  # end

  # def gateway_token
  #   APP_CONFIG.spreedly.env_card
  # end

  # def render_unable_to_process(transaction)
  #   flash.now[:error] = transaction.message
  #   render_transaction
  # end

  # def handle_spreedly_error(error)
  #   flash.now[:error] = error.message
  #   render_transaction
  # end
end
























 
