class PasswordResetsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:email])
    user.send_password_reset(user)
    redirect_to root_url, :notice => I18n.t("password_resets.email_sent")
  end
  
  def edit
    @user = User.find_by(password_reset_token: params[:id])
  end
  
  def update
    @user = User.find_by(password_reset_token: params[:id])
    if @user.password_reset_sent_at < 2.hours.ago
      redirect_to new_password_reset_path, :alert => I18n.t("password_resets.expired")
    else
      @user.update_attributes(permitted_params.user)
      @identity = Identity.find_by email: @user.email 
      @identity.password = @user.password
      @identity.password_confirmation = @user.password_confirmation
      if @identity.save        
        redirect_to root_url, :notice => I18n.t("password_resets.password_has_been_reset")
      else
        redirect_to root_url, :notice => I18n.t("password_resets.error_in_password_reset")
      end          
    end
  end
end
