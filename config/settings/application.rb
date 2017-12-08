# DO NOT SET SENSITIVE DATA HERE!
# USE ENVIRONMENT VARIABLES OR 'local.rb' INSTEAD

# OVERRIDE THESE DEFAULTS IN A PROPER ENVIRONMENT CONFIGURATION FILE
# SET SENSITIVE DATA ONLY IN 'local.rb'

SimpleConfig.for :application do
  set :app_name, 'HizmetKutusu'
  set :repository_url, 'https://github.com/canercak/hizmetkutusu'
  set :available_locales, Hash[{ :tr => 'Türkçe', :en => 'English (US)',  :az => 'Azerice' }.sort_by { |_, native_name| native_name }]
  set :demo_mode, false
  set :base_url, '0.0.0.0:3000'
  set :secret_token, '197241fc4c041de6402aa732e0004c5401536237a1c39178005ddf9994695cfc71fb32b543f8fb216f272b416974e3ea3cece241278a40a8516291aec598a948'
  set :single_process_mode, true
  set :google_analytics_id, nil
  set :google_maps_api_key, nil
  set :sms_from, "8503026096"

  group :facebook do
    set :namespace, 'FACEBOOK_NAMESPACE'
    set :app_id, 'FACEBOOK_APP_ID'
    set :app_secret, 'FACEBOOK_SECRET'
    set :scope, 'email, publish_stream, user_birthday, user_about_me, user_education_history, user_interests, user_likes, user_religion_politics, user_work_history'
    set :cache_expiry_time, 7.days
    set :restricted_group_id, nil
  end

  group :foursquare do
    set :client_id, 'SB0BXJWLGU4F11VX0QIMJ1M5IZK0ENFIWYBHO3ZI5GCJNFTQ'
    set :client_secret, 'A5SP31BAATUPIIWKD3ZC2EMYFGXXHZKJZWBLN3Y3FNER0RIC'
    set :cache_expiry_time, 2.days
  end
 
 
  group :mailer do
    set :from, "\"Hizmetkutusu\" <iletisim@hizmetkutusu.com>"
    set :host, '127.0.0.1'

    group :smtp_settings do
      set :address, 'smtp.sendgrid.net'
      set :port, 587
      set :authentication, :plain
      set :domain, 'heroku.com' 
      set :user_name, 'app20881436@heroku.com'
      set :password, '873gawvr'
    end
  end

  group :redis do
    set :url, 'redis://127.0.0.1:6379'
  end

  group :resque do
    set :user_name, 'admin'
    set :password, 'admin'
  end
end
