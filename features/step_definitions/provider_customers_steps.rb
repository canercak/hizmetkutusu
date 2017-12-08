Given(/^I am on new customers page$/) do
   visit new_provider_customer_path(:provider_id=>@@provider._id)
end
 
Given(/^I have not defined my web\-access$/) do
end

When(/^I enter phone  "(.*?)" which is not in the system$/) do |arg1|
  expect(User.first.check_phone(arg1)).to be_nil 
  fill_in("customer_phone", :with=>arg1)
end

When(/^I enter email "(.*?)"$/) do |arg1|
 fill_in("customer_email", :with=>arg1)
end

When(/^I enter name "(.*?)"$/) do |arg1|
  fill_in("customer_name", :with=>arg1)
end 
When(/^I select "(.*?)" type$/) do |arg1| 
  select(arg1, :from => "customer_person_type")
end 

When(/^I enter address "(.*?)"$/) do |arg1|
  fill_in("customer_address", :with=>arg1)
end

When(/^I submit customer form$/) do
  click_button("save_customer")
end 
 

Then(/^I should see saved customer "(.*?)"  on the list$/) do |arg1|
   page.should have_content arg1
end


Then(/^customer should get invitation by email$/) do
 
end

Then(/^customer should get invitation by phone$/) do
 
end
