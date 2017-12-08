require File.expand_path('../boot', __FILE__)

require "action_controller/railtie"
require "action_mailer/railtie"
#require "active_resource/railtie"
require "rails/test_unit/railtie"
require "sprockets/railtie"
#require "mongoid/railtie"
 

if defined?(Bundler)
  # precompile assets before deploying to production 
  Bundler.require(*Rails.groups(assets: %w(development test)))
  # assets lazily compiled in production
  # Bundler.require(:default, :assets, Rails.env)
end

module Hizmetkutusu
  class Application < Rails::Application

    # Custom directories with classes and modules you want to be autoloadable.
    config.autoload_paths += %W(
      #{config.root}/app/models/concerns
    #{config.root}/lib/*
 
    )


    # initializer 'setup_asset_pipeline', :group => :all  do |app|
    #   # We don't want the default of everything that isn't js or css, because it pulls too many things in
    #   app.config.assets.precompile.shift

    #   # Explicitly register the extensions we are interested in compiling
    #   app.config.assets.precompile.push(Proc.new do |path|
    #     File.extname(path).in? [
    #       '.html', '.erb', '.haml',                 # Templates
    #       '.png',  '.gif', '.jpg', '.jpeg',         # Images
    #       '.eot',  '.otf', '.svc', '.woff', '.ttf', # Fonts
    #     ]
    #   end)
    # end
    # config.assets.version = '1.0'
 
    # Only load the plugins named here, in the order given (default is alphabetical).
    # :all can be used as a placeholder for all plugins not explicitly named.
    # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

    # Activate observers that should always be running.
    # config.active_record.observers = :cacher, :garbage_collector, :forum_observer
    # config.mongoid.observers = :quote_observer  # removed from mongoid 4

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]
    
    #config.i18n.enforce_available_locales = false
    config.i18n.available_locales = :en, :tr, :az
    config.i18n.default_locale = :tr
 #I18n.locale = config.i18n.locale = config.i18n.default_locale

    #config.filepicker_rails.api_key = "AifOPz2tfQYCwK9uHOndcz"

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"
    config.force_ssl = true

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password]

    # Use SQL instead of Active Record's schema dumper when creating the database.
    # This is necessary if your schema can't be completely dumped by the schema dumper,
    # like if you have constraints or database-specific column types
    # config.active_record.schema_format = :sql

    # Enforce whitelist mode for mass assignment.
    # This will create an empty whitelist of attributes available for mass-assignment for all models
    # in your app. As such, your models will need to explicitly whitelist or blacklist accessible
    # parameters by using an attr_accessible or attr_protected declaration.
    # config.active_record.whitelist_attributes = true

    # Enable the asset pipeline
    config.assets.enabled = true
    config.assets.initialize_on_precompile = true
    config.serve_static_assets = true

    # Version of your assets, change this if you want to expire all your assets
 
    config.generators do |g|
      g.template_engine :haml
      g.fixture_replacement :fabrication
    end
 
    # Logging with Unicorn on Heroku
    config.logger = Logger.new(STDOUT)
  end
end
