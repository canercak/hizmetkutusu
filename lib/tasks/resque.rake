require 'resque/tasks'
# require 'resque_scheduler/tasks'
require 'yaml'

task "resque:setup" => :environment do
  require 'resque'
  # require 'resque_scheduler'
  # require 'resque/scheduler'
  require 'yaml'
  

  ENV['QUEUE'] = '*'
  #Resque.schedule = YAML.load_file('config/resque_schedule.yml')
end

desc "Alias for resque:work (To run workers on Heroku)"
task "jobs:work" => "resque:work"

 
