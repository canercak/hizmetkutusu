Given(/^I am on my prices page$/) do
  visit prices_provider_path(@@provider._id)
end

Given(/^I see  "(.*?)" and "(.*?)" with its price "(.*?)"$/) do |arg1, arg2, arg3|
   page.should  have_content(arg1)
   page.should have_content(arg2)
   page.should  have_content(arg3)
end

Given(/^I see its hours "(.*?)"$/) do |arg1|

end

When(/^I change its hours to "(.*?)"$/) do |arg1|
	id = @@provider.workdones.first._id.to_s
	duration = "workdone_"+id+"_duration0"
	select(arg1, :from => duration) 
end

When(/^I submit price form$/) do
  page.find(:css, '#save_prices').trigger('click')
end

Then(/^hours of should be updated to "(.*?)"$/) do |arg1|
 #expect(find("option[selected='selected']").text).to eq(arg1)
 #to-do
end 
 
Given(/^I have "(.*?)" and "(.*?)" as my staff members$/) do |arg1, arg2|
	@@user1 = Fabricate(:user, name: arg1)
	@@user2 = Fabricate(:user, name: arg2)
	@@provider.workdones.first.prices.first.staff_ids = [current_user._id]
	@@provider.save!
  staff1 = Fabricate(:customer, provider: @@provider, user_id: @@user1._id, person_type: 1) 
  staff2 = Fabricate(:customer,provider: @@provider,  user_id: @@user2._id, person_type: 1)
end
 
Given(/^I see my name as the staff member$/) do
  page.should have_content(current_user.name)
end

When(/^I select "(.*?)" and "(.*?)" as staff members$/) do |arg1, arg2|
	page.find(:css, ".multiselect.dropdown-toggle.btn.btn-default", visible: true).click
	check(arg1)
	check(arg2)
end

Then(/^"(.*?)" and "(.*?)" shoudl be staff members$/) do |arg1, arg2|
	 expect(@@provider.workdones.first.prices.first.staff_ids).not_to be nil 
end
 







 