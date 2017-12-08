# encoding: UTF-8
class UsersController < ApplicationController
  include Transloadit::Rails::ParamsDecoder
  include UsersHelper
  before_filter :set_user_as_current_user, only: [:update, :dashboard, :settings, :quotes, :providers, :financialsettings]
  before_filter :require_login, except: [:check_email]

  def show
    @user = User.find(params[:id])
    @current_phones = current_user.providers.map {|p| p.business_phone}
 
  end

  def edit
  end

  def check_email
    @user = User.find_by(email: params[:email])
    respond_to do |format|
     format.json { render :json => !@user }
    end
  end

  def check_phone_exists
   data = current_user.check_phone(params[:phone])
    respond_to do |format|
     format.json { render :json => data}
    end 
  end

  def get_user
    user= User.find(params[:id])
    data = user
    respond_to do |format|
      format.json { render :json => data}
    end
  end
 
  
  def update
    @user.time_zone = params[:user]["time_zone"]
    @user.locale = params[:user]["locale"]
    @user.send_email_references = params[:user]["send_email_references"]
    @user.send_email_statistics = params[:user]["send_email_statistics"]
    @user.send_email_newsletter = params[:user]["send_email_newsletter"]
    if (params[:user]["email"] != @user.email) && @user.oauth_token.blank?
      identity = Identity.find_by(:email=>@user.email)
      identity.email = params[:user]["email"]
      identity.save!
    end
    if params[:user][:password].present? && (params[:user][:password] == params[:user][:password_confirmation])
      identity = Identity.find_by(:email=>params[:user]["email"])
      identity.password = params[:user][:password]
      identity.save!
    end
    if current_user.phone_verified == false && session[:mobile_verified] == true
      @user.phone_verified = true
      @user.telephone= validate_phone(user_params["telephone"])
      session[:mobile_verified] = false
    end
    if @user.save!
      redirect_to :settings, flash: { success: t('flash.users.success.update') }
    else
      redirect_to :settings, flash: { error: t('flash.users.errror.update') }
    end
  end

  def destroy
    if current_user.destroy
      session[:user_id] = nil
      redirect_to root_path, flash: { success: t('flash.users.success.destroy') }
    else
      redirect_to new_quote_path, flash: { error: t('flash.users.error.destroy') }
    end
  end

  def dashboard
 
    @user = current_user
    @latest_quotes = @user.quotes.desc :created_at
    #redirect_to dashboard_path
  end
  
  def financialsettings       
     @transactions = @user.transactions.desc :created_at
  end
  
  def references 
    references = quote.provider.references.to_a
    arr =[]
    references.each do |ref|
      if ref[0].user_id = current_user.id
        arr<<ref[0]
      end
      @references = arr ##todo
     end  
  end

  def quotes
    @quotes = @user.quotes.desc :created_at

  end
  
   def providers   
    @providers = @user.providers.desc :created_at
  end

  def banned
    redirect_to root_path unless current_user.banned?
  end

  private
  def set_user_as_current_user
    @user = current_user
  end

  def user_params
    params.required(:user).permit(:time_zone, :locale, :telephone, :credits, :useridentity_image, :useridentity_image_cache, :ammount, :phone_verified )
  end 
end
