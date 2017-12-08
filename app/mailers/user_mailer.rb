class UserMailer < ActionMailer::Base
  include Resque::Mailer
  default from: APP_CONFIG.mailer.from
 
  def welcome_email(user, email, admin_password)
    @user = user
    I18n.locale = I18n.default_locale
    url = ""
    if user["provider"] == "facebook"
      url  = "#{APP_CONFIG.base_url}/auth/facebook"
    else
      url  = "#{APP_CONFIG.base_url}/sessions/new"
    end
    @content = {}
    @content[:body_title] = I18n.t('provider_mailer.registration_email.body_title', username: user["name"])
    @content[:body_subtitle] = I18n.t('user_mailer.welcome_email.body_subtitle')
    @content[:body_content] = I18n.t('user_mailer.welcome_email.body_content')
    # @content[:body_link] = url
    # @content[:body_link_title] = I18n.t('user_mailer.welcome_email.body_link_title')
    #@content[:body_link_title] = (admin_password.blank? ? I18n.t('user_mailer.welcome_email.body_link_title') : I18n.t('user_mailer.welcome_email.body_link_title_with_pass', email: email, admin_password: admin_password))
    mail(to: user["email"], subject: t('user_mailer.welcome_email.subject')) 
  end

  def invitation_email(user, otp_code, provider)
    I18n.locale = I18n.default_locale 
    @content = {} 
    @content[:body_title] = I18n.t('user_mailer.invitation_email.body_title', username: user["name"])
    @content[:body_subtitle] = I18n.t("user_mailer.invitation_email.body_subtitle", provider: provider["officialname"])
    @content[:body_content] = I18n.t("user_mailer.invitation_email.body_content", otp: otp_code)
    @content[:body_link] = "#{APP_CONFIG.base_url}/fiyat-veren/#{provider["slug"]}"
    @content[:body_link_title] =I18n.t("user_mailer.invitation_email.body_link_title")
    mail(to: user["email"], subject: t('user_mailer.invitation_email.subject')) 
  end

  def customer_email(user, provider)
    I18n.locale = I18n.default_locale 
    user = User.find(user["_id"])
    @content = {}
    @content[:body_title] = I18n.t('user_mailer.add_customer_email.body_title', username: user["name"])
    @content[:body_subtitle] = I18n.t("user_mailer.add_customer_email.body_subtitle", provider: provider["officialname"])
    @content[:body_content] = I18n.t("user_mailer.add_customer_email.body_content:")
    @content[:body_link] = "#{APP_CONFIG.base_url}/fiyat/yeni"
    @content[:body_link_title] =I18n.t("user_mailer.add_customer_email.body_link_title")
    mail(to: user["email"], subject: t('user_mailer.add_customer_email.subject')) 
  end

  def new_quote_email(email, message,quote) 
    I18n.locale = I18n.default_locale 
    user = User.find(quote["user_id"])
    @content = {}
    @content[:body_title] = I18n.t('user_mailer.new_quote_email.body_title', username: user["name"])
    @content[:body_subtitle] = I18n.t('user_mailer.new_quote_email.body_subtitle' )
    @content[:body_content] = message
    @content[:body_link] = "#{APP_CONFIG.base_url}/fiyat/#{quote._id}"
    @content[:body_link_title] =I18n.t('user_mailer.new_quote_email.body_link_title')
    mail(to: email, subject: t('user_mailer.new_quote_email.subject')) 
 
  end 

  def password_reset_email(user)
    I18n.locale = I18n.default_locale 
    user = User.find(user["_id"])
    @content = {}
    @content[:body_title] = I18n.t('user_mailer.new_quote_email.body_title', username: user["name"])
    @content[:body_subtitle] = I18n.t("user_mailer.pass_reset_head")
    @content[:body_content] = I18n.t("user_mailer.pass_reset_body1")
    @content[:body_link] = "#{edit_password_reset_url(user.password_reset_token)}"
    @content[:body_link_title] =I18n.t("user_mailer.pass_reset_link_button")
    mail(to: user["email"], subject: t('user_mailer.pass_reset.subject')) 
  end
  
  def comment_email(quote) 
    @user = User.find(quote["user_id"])
    I18n.locale = I18n.default_locale
    url  = "#{APP_CONFIG.base_url}/login"
    @content = {}
    @content[:body_title] = I18n.t('provider_mailer.registration_email.body_title', username: get_first_name(@quote.user.name))
    @content[:body_subtitle] = I18n.t('user_mailer.comment_email.body_subtitle')
    @content[:body_content] = I18n.t('user_mailer.comment_email.body_content')
    @content[:body_callout] = I18n.t('user_mailer.comment_email.body_callout')
    @content[:body_link] = url
    @content[:body_link_title] =I18n.t('user_mailer.comment_email.body_link_title')
    mail(to: user["email"], subject: t('user_mailer.comment_email.subject')) 
  end

end
