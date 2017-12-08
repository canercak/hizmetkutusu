require 'simplecov'
require 'transloadit/rspec/helpers'
require File.expand_path('../../config/environment', __FILE__)
require 'capybara/poltergeist'
require 'rspec/rails'
require 'rspec/autorun'
#require 'webmock/rspec'
require 'capybara/rspec'
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

ENV['RAILS_ENV'] ||= 'test'

SimpleCov.command_name 'Rspec'
SimpleCov.start 'rails'
 
Capybara.javascript_driver = :poltergeist

RSpec.configure do |config|
  config.order = 'random'
  config.color = true
  config.include Delorean
  config.before(:each) do
    back_to_the_present
  end
end

# RSpec.configure do |config|
#   config.before(:each) do
#      stub_request(:get, "http://maps.googleapis.com/maps/api/geocode/json?address=Bostanl%C4%B1%20Mh.,%206352.%20Sokak%20No:15,%2035480%20%C4%B0zmir,%20T%C3%BCrkiye&language=en&sensor=false").
#          with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Host'=>'maps.googleapis.com', 'User-Agent'=>'Ruby'}).
#          to_return(:status => 200, :body => "", :headers => {}) 

#    stub_request(:put, "http://localhost:9200/categories_test/category/5390e7ba63616e56f5050000").
#          with(:body => {"{\"ancestors\":"=>{"\"Ki\xC5\x9Fisel Bak\xC4\xB1m Hizmetleri\",\"Sa\xC3\xA7 Bak\xC4\xB1m\xC4\xB1\",\"Boyama\""=>{",\"parent\":\"Boyama\",\"title\":\"Dip Boya\"}"=>true}}},
#               :headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Type'=>'application/x-www-form-urlencoded', 'User-Agent'=>'Faraday v0.9.0'}).
#          to_return(:status => 200, :body => "", :headers => {})

#  stub_request(:post, "http://api.netgsm.com.tr/xmlbulkhttppost.asp").
#          with(:body => "<?xml version=\"1.0\"?>\n<mainbody>\n  <header>\n    <company>NETGSM</company>\n    <usercode>5322814785</usercode>\n    <password>3X7G3H8</password>\n    <type>n:n</type>\n    <msgheader>8503026096</msgheader>\n  </header>\n  <body/>\n</mainbody>\n",
#               :headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
#          to_return(:status => 200, :body => "", :headers => {})
       
 
#        stub_request(:put, "http://localhost:9200/categories_test/category/5390e7ba63616e56f5050000").
#          with(:body => {"{\"ancestors\":"=>{"\"Kişisel Bakım Hizmetleri\",\"Saç Bakımı\",\"Boyama\""=>{",\"parent\":\"Boyama\",\"title\":\"Dip Boya\"}"=>true}}},
#               :headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Type'=>'application/x-www-form-urlencoded', 'User-Agent'=>'Faraday v0.9.0'})
#        stub_request(:get, "http://maps.googleapis.com/maps/api/geocode/json?address=Bostanl%C4%B1%20Mh.,%206352.%20Sokak%20No:15,%2035480%20%C4%B0zmir,%20T%C3%BCrkiye&language=en&sensor=false").
#          with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Host'=>'maps.googleapis.com', 'User-Agent'=>'Ruby'})


#        stub_request(:post, "https://www.googleapis.com/urlshortener/v1/url").
#          with(:body => "{\"longUrl\":\"0.0.0.0:3000/users/Gutmann\"}",
#               :headers => {'Content-Type'=>'application/json'}).
#          to_return(:status => 200, :body => "", :headers => {})
       


#         Kernel.

#        stub_request(:post, "https://www.googleapis.com/urlshortener/v1/url").
#          with(:body => "{\"longUrl\":\"0.0.0.0:3000/users/Bartoletti\"}",
#               :headers => {'Content-Type'=>'application/json'}).
#          to_return(:status => 200, :body => "", :headers => {})
       


#   end
# end

   


#   WebMock.disable_net_connect! allow: 'graph.facebook.com', allow_localhost: true
#   WebMock.disable_net_connect! allow: 'maps.googleapis.com', allow_localhost: true
#   WebMock.disable_net_connect! allow: 'googleapis.com/urlshortener/v1/url', allow_localhost: true

 

