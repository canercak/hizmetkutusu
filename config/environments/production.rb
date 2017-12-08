Hizmetkutusu::Application.configure do

  config.middleware.use Rack::Deflater
  config.force_ssl = false
  config.cache_classes = true
  config.eager_load = true
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true
  config.serve_static_assets = true
  config.assets.compress = true
  config.assets.digest = true 
  config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect'
  config.assets.compile = true 
  config.assets.debug = false
  config.i18n.fallbacks = true
  config.active_support.deprecation = :notify
  config.action_mailer.default_url_options = { host: APP_CONFIG.mailer.host }
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.perform_deliveries = true
  config.action_mailer.raise_delivery_errors = false
  config.action_mailer.default charset: 'utf-8'
  config.action_mailer.default from: APP_CONFIG.mailer.from
  config.action_mailer.smtp_settings = {
    address: APP_CONFIG.mailer.smtp_settings.address,
    port: APP_CONFIG.mailer.smtp_settings.port,
    authentication: APP_CONFIG.mailer.smtp_settings.authentication,
    user_name: APP_CONFIG.mailer.smtp_settings.user_name,
    password: APP_CONFIG.mailer.smtp_settings.password,
    domain: APP_CONFIG.mailer.smtp_settings.domain,
    enable_starttls_auto: true
  }

  # Google Analytics
  GA.tracker = APP_CONFIG.google_analytics_id if APP_CONFIG.exists? :google_analytics_id
end
