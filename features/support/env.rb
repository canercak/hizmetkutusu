ENV["RAILS_ENV"] ||= 'test'
require 'cucumber/rails'
require 'capybara'
require 'capybara-select2'
require 'database_cleaner'
require 'database_cleaner/cucumber'
require 'capybara/dsl'
require 'rspec/expectations'
require 'capybara/cucumber'
require 'rspec/expectations' 
require 'capybara/poltergeist'
require 'transloadit/rspec/helpers'

Capybara.default_driver = :poltergeist 
Capybara.default_selector= :css
Capybara.ignore_hidden_elements = false
Capybara.app_host = "http://0.0.0.0:3000"
Capybara.server_host = "0.0.0.0"
Capybara.server_port = "3000" 
Capybara.default_wait_time = 8
Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, { debug: false, 
  																				 js_errors: false,
  																				 window_size: [1280, 1024]
  })
end
Capybara.javascript_driver = :poltergeist
 
Before('@omniauth_test') do
  OmniAuth.config.test_mode = true
  Capybara.default_host = 'http://example.com'
  @old_mocked_authhash = OMNIAUTH_MOCKED_AUTHHASH
  OmniAuth.config.mock_auth[:facebook] = OMNIAUTH_MOCKED_AUTHHASH.merge extra: { raw_info: { gender: 'female' } }
  OmniAuth.config.mock_auth[:facebook] = @old_mocked_authhash
end

After('@omniauth_test') do
  OmniAuth.config.test_mode = false
end
 
Before do |scenario|
  DatabaseCleaner.clean 
end
def page!
  save_and_open_page
end
 
ActionController::Base.allow_rescue = false
DatabaseCleaner[:mongoid].strategy = :truncation
Cucumber::Rails::Database.javascript_strategy = :truncation

