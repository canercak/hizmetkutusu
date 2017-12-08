
SimpleConfig.for :application do
  set :base_url, 'www.hizmetkutusu.com'
  set :secret_token, ENV['SECRET_TOKEN']
  set :single_process_mode, false

  set :google_analytics_id, ENV['GOOGLE_ANALYTICS_ID']
  set :google_maps_api_key, ENV['GOOGLE_MAPS_API_KEY']

  group :facebook do
    set :namespace, ENV['FACEBOOK_NAMESPACE']
    set :app_id, ENV['FACEBOOK_APP_ID']
    set :app_secret, ENV['FACEBOOK_SECRET']
  end
 
 
  group :mailer do
    set :from, "\"Hizmetkutusu\" <no-reply@hizmetkutusu.com>"
    set :host, 'heroku.com'

    group :smtp_settings do
      set :address, 'smtp.sendgrid.net'
      set :port, 587
      set :authentication, :plain
      set :domain, 'heroku.com'
      set :user_name, ENV['SENDGRID_USERNAME']
      set :password, ENV['SENDGRID_PASSWORD']
    end
  end

 
  group :mongolab do 
    set :mongolab_uri, ENV['MONGOLAB_URI']
  end
  
  group :redis do
    set :url, ENV['REDISTOGO_URL'] || "redis://redistogo:867eeea8b42fdab5e5db5819bebd79ec@cod.redistogo.com:10431/"
  end

  group :resque do
    set :user_name, ENV['RESQUE_WEB_USER']
    set :password, ENV['RESQUE_WEB_PASSWORD']
  end
end
