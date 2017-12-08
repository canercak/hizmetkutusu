class ProviderMailer < ActionMailer::Base
  include Resque::Mailer
  include ApplicationHelper
  default from: APP_CONFIG.mailer.from
 
  def registration_email(provider, email, admin_password)
    I18n.locale = I18n.default_locale
    @provider= Provider.find(provider["_id"])
    provider_url  = "#{APP_CONFIG.base_url}/fiyat-veren/#{provider["_id"]}"
    @content = {}
    @content[:template_label] = I18n.t('provider_mailer.registration_email.template_label')
    @content[:body_title] = I18n.t('provider_mailer.registration_email.body_title', username: @provider.user.name)
    @content[:body_subtitle] = I18n.t('provider_mailer.registration_email.body_subtitle')
    @content[:body_content] = I18n.t('provider_mailer.registration_email.body_content', provider_email: @provider.user.email, provider_phone: @provider.user.telephone)
    # @content[:body_callout] =I18n.t('provider_mailer.registration_email.body_callout')
    
    # @content[:body_link] = provider_url
    # @content[:body_link_title] = I18n.t('provider_mailer.registration_email.body_link_title')
    #@content[:body_link] = admin_password.blank? ? provider_url :  "#{APP_CONFIG.base_url}/sessions/new"
    #@content[:body_link_title] = (admin_password.blank? ? I18n.t('provider_mailer.registration_email.body_link_title') : I18n.t('provider_mailer.registration_email.body_link_title_with_pass', email: email, admin_password: admin_password))
    mail(to: provider["business_email"], subject: t('provider_mailer.registration_email.subject')) 
  end

  def new_quote_email(email, message, quote) 
    I18n.locale = I18n.default_locale 
    user = User.find(quote["user_id"])
    @content = {}
    @content[:body_title] = I18n.t('provider_mailer.new_quote_email.body_title', username: user.name)
    @content[:body_subtitle] = I18n.t('provider_mailer.new_quote_email.body_subtitle' )
    @content[:body_content] = message
    @content[:body_link] = "#{APP_CONFIG.base_url}/fiyat/#{quote._id}"
    @content[:body_link_title] =I18n.t('provider_mailer.new_quote_email.body_link_title')
    mail(to: email, subject: t('provider_mailer.new_quote_email.subject')) 
 
  end 
  
  def return_quote_email(quote, provider) 
      I18n.locale = I18n.default_locale
      @quote=Quote.find(quote["_id"])
      shortlink= ""
      quotefinish= ""
      @content = {}
      @content[:body_title] = I18n.t('provider_mailer.return_quote_email.body_title', username: get_first_name(@quote.user.name))
      @content[:body_subtitle] = I18n.t('provider_mailer.return_quote_email.body_subtitle' )
      @content[:body_content] = @quote.call_with_phone == false ? I18n.t('provider_mailer.return_quote_email.body_content_without_phone', username: get_first_name(@quote.user.name)) :
                                                          I18n.t('provider_mailer.return_quote_email.body_content_without_phone', username: get_first_name(@quote.user.name), telephone: @quote.user.telephone, shortlink: shortlink)
      @content[:body_callout] =I18n.t('provider_mailer.return_quote_email.body_callout', quotefinish: quotefinish)
      @content[:body_link] = shortlink
      @content[:body_link_title] =I18n.t('provider_mailer.return_quote_email.body_link_title')
      mail(to: provider["business_email"], subject: t('provider_mailer.return_quote_email.subject')) 
  end

  def credit_email(provider) 
    I18n.locale = I18n.default_locale
    shortlink= ""
    @content = {}
    @content[:body_title] = I18n.t('provider_mailer.credit_email.body_title', username: provider.user.name)
    @content[:body_subtitle] = I18n.t('provider_mailer.credit_email.body_subtitle')
    @content[:body_content] = I18n.t('provider_mailer.credit_email.body_content')
    @content[:body_callout] =I18n.t('provider_mailer.credit_email.body_callout')
    @content[:body_link] = shortlink
    @content[:body_link_title] =I18n.t('provider_mailer.credit_email.body_link_title')
    mail(to: provider["business_email"], subject: t('provider_mailer.credit_email.subject'))   
  end
end
