# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment',  __FILE__)
require 'yaml'

#if Rails.env.production?
#  DelayedJobWeb.use Rack::Auth::Basic do |username, password|
#    username == 'canercak' && password == 'caner900'
#  end
#end
run Hizmetkutusu::Application
