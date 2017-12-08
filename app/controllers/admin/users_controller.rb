class Admin::UsersController < Admin::BaseController
  before_filter :prevent_autoban, only: [:ban, :unban ]
  before_filter :check_admin
  before_filter :require_login 
  def index
    @users = User.includes(:providers).asc(:name).page params[:page]  
   # @users = User.asc(:name, :include => :providers, :page => params[:page], :per_page => 20 )
  end

  def login_as
    user = User.find params[:id]
    session[:user_id] = user.id.to_s
    redirect_to new_quote_path
  end


  def ban
    if @user.update_attributes(banned: true)
      redirect_to admin_users_path, flash: { success: t('flash.admin.users.success.ban') }
    else
      redirect_to admin_users_path, flash: { error: t('flash.admin.users.error.ban') }
    end
  end

  def unban
    if @user.update_attributes(banned: false)
      redirect_to admin_users_path, flash: { success: t('flash.admin.users.success.unban') }
    else
      redirect_to admin_users_path, flash: { error: t('flash.admin.users.error.unban') }
    end
  end
  
  def manualcredits
    @user = User.find params[:id]
  end
  
  def addcredit
    user = User.find params[:id]
    ammount = user.credits + params[:amount].to_i
      if user.update_attributes(credits: ammount)
        @stored_transaction = Transaction.new
        @stored_transaction.amount = params[:amount].to_i        
        if params[:manual_payment_type] == t('users.financialsettings.bank_transfer_purchase')    
          @stored_transaction.type = 3
        else
          @stored_transaction.type = 5
        end          
        @stored_transaction.user_id = user.id
        @stored_transaction.done_by = current_user.id
        @stored_transaction.save
        redirect_to admin_users_path, flash: { success: t('flash.admin.users.success.creditadded') }
      else
        redirect_to admin_users_path, flash: { error: t('flash.admin.users.error.creditnotadded') }
      end  
  end
  
  def refunds 
    @user = User.find params[:id]
    @transactions = Transaction.where(:user_id=>@user.id).order_by(:created_at.desc)
  end 
  
  private
  def prevent_autoban
    @user = User.find params[:id]
    redirect_to admin_users_path, flash: { error: t('flash.admin.users.error.ban') } if @user == current_user
  end
end
