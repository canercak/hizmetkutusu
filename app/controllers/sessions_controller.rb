class SessionsController < ApplicationController

  skip_before_filter :require_login, except: [:destroy]

  def create
    auth = env['omniauth.auth']
    current_identity = nil
    if (auth.provider == "facebook")
      current_identity = User.define_identity(auth.extra[:raw_info][:email])
    else
      user = User.find_by(email:params[:email])
      if params[:otp].present?
        otp_result = (user.authenticate_otp(params[:otp], drift: 100000))
        if user.present? && otp_result == false
          redirect_to "/identities/new/", flash: { error: t( 'flash.sessions.error.email_exists_otp')}
          return
        end
      else
        if user.present? 
          redirect_to "/identities/new/", flash: { error: t( 'flash.sessions.error.email_exists')}
          return
        end 
      end
      current_identity = User.define_identity(auth.info.email)
    end 
    if (user = User.from_omniauth(env['omniauth.auth'], current_identity))
      session[:user_id] = user.id.to_s 
      clear_quote_session
      redirect_to session.delete(:redirect_to) || (user.providers.blank? ? new_quote_path : provider_path(user.providers.first.slug))
    else
      redirect_to root_path, flash: { error: t(APP_CONFIG.facebook.restricted_group_id ? 'flash.sessions.error.restricted' : 'flash.sessions.error.create') }
    end
  end

  def destroy
    session[:user_id] = nil
    clear_quote_session
    redirect_to root_path
  end
  
  def failure
    redirect_to new_sessions_path,  flash: { success:  t('shared.navbar.sign_in_fail') }  
  end
  
  def new
    #redirect_to root_path, flash: { error: I18n.t("shared.navbar.wrong_password")}
  end

  
 
  
end
