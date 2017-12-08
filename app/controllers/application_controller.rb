class ApplicationController < ActionController::Base
  include PublicActivity::StoreController
  include HTTParty
 
  ensure_security_headers
  protect_from_forgery
  #before_filter :require_login
  before_filter :set_locale
  before_filter :check_banned, except: [:banned]
  before_filter :set_user_time_zone, if: :logged_in?
  helper_method :current_user, :logged_in?, :permitted_params
  helper_method :getproviderworkdone
  has_mobile_fu false
  #rescue_from StandardError, :with => :error_render_method
   

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end
 
  include ApplicationHelper
 
  def getproviderworkdone
    @quote = current_user.quotes.find params[:id]
    @quote.provider
  end 
  
  
  def increment_login_count
    data = {:result => false}
    count = current_user.login_count + 1
    if current_user.update_attributes(login_count: count )
      data = {:result => true}
    end
    respond_to do |format|
      format.json  { render :json => data} 
    end
  end


    
  def check_verification_code 
     data = {:result => false}
    if current_user.authenticate_otp(params[:verification_code], drift: 200) #drift enough for old users 
      data = {:result => true}
      session[:mobile_verified] = true
    end
    respond_to do |format|
      format.json  { render :json => data} 
    end
  end

 
  def sendverification
    data = {:result => false} 
    phone = validate_phone(params[:verification_phone])
    if phone.present?
      sms = Sms.new 
      otp = current_user.otp_code.to_s  
      puts otp
      if sms.send_multi_sms([phone], [t('verification_message') + otp],  "verify_provider", nil) 
        # send_single_sms(phone, t('verification_message') + otp, nil, "newprovider", nil)
        data = {:result => true, :otp=>otp} 
      end
    end
    respond_to do |format|
      format.json  { render :json => data} 
    end
  end
  
  
  protected
  def set_locale
    I18n.locale = check_locale_availability(params[:locale] || (current_user.locale if logged_in?)) 
  end

  def require_login
    redirect_to root_path, flash: { error: t('flash.errors.not_authenticated') } unless logged_in?
  end

  def check_admin
    redirect_to root_path, flash: { error: t('flash.errors.not_allowed') } if logged_in? && !current_user.admin?
  end
 
  def check_banned
    redirect_to :banned if logged_in? && current_user.banned?
  end

  def find_user(param)
    # TODO Optimization?
    User.find_by({ username_or_uid: param })
  end
  
   def find_provider(param)
    # TODO Optimization?
    Provider.find_by({ officialname: param })
  end
  
  def find_providerbyid(param)
    # TODO Optimization?
    Provider.find_by({ id: param })
  end
  
  
  def find_quote(param)
    # TODO Optimization?
    Quote.find_by({ id: param })
  end

  if Rails.env.test?
  prepend_before_filter :stub_current_user

  def stub_current_user
    session[:user_id] = cookies[:stub_user_id] if cookies[:stub_user_id]
  end
 end

  private
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  rescue
    session[:user_id] = nil
  end
  

  def logged_in?
    current_user.present?
  end
   

  def set_user_time_zone
    Time.zone = current_user.time_zone
  end

  def check_locale_availability(locale)
    locale if locale.present? && I18n.available_locales.include?(locale.to_sym)
  end 

  # def error_render_method
  #   respond_to do |type|
  #     type.html { render :template => "errors/error_404", :status => 404 }
  #     type.all  { render :nothing => true, :status => 404 }
  #   end
  #   true
  # end

 
end
