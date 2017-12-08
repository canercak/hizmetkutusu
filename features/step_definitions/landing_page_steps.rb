
Given(/^I am a customer$/) do
  expect(User.all.to_a.count).to equal 0
end
 
When(/^I click signup$/) do
  visit new_identity_path
end

When(/^I click log in$/) do
  visit new_session_path
end

When(/^I enter my email "(.*?)"$/) do |arg1|
  fill_in 'email', :with =>  arg1
end

When(/^I enter my name "(.*?)"$/) do |arg1|
    fill_in 'name', :with =>  arg1
end

When(/^I enter my password "(.*?)"$/) do |arg1|
    fill_in 'password', :with =>  arg1
end

When(/^I confirm my password "(.*?)"$/) do |arg1|
    fill_in 'password_confirmation', :with =>  arg1
end

When(/^I submit the signup form$/) do
   page.find(:css, ".btn.btn-primary").click
end

Then(/^I should be on my home page$/) do
 #expect(URI.parse(current_url).request_uri).to eq("/auth/identity/register")
#{}" new_quote_path
end

Then(/^I should get welcome email$/) do
 
end
 


When(/^I enter my login email  "(.*?)"$/) do |arg1|
  fill_in 'auth_key', :with => arg1
end

When(/^I enter my login password  "(.*?)"$/) do |arg1|
    fill_in 'password', :with =>  arg1
end

When(/^I submit the login form$/) do
  page.find(:css, ".btn.btn-primary").click
end
 