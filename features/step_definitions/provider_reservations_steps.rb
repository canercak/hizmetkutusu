Given(/^I am on my reservations page$/) do
  #@@staff_user1 = Fabricate(:user, name:"John Warwick")
  @@customer_user1 = Fabricate(:user, name:"John Warwick")
  @@customer_user2 = Fabricate(:user, name:"Alison Birgade") 
  @@customer1 = Fabricate(:customer, user_id: @@customer_user1._id, provider: @@provider, person_type: 1)
  @@customer2 = Fabricate(:customer, user_id: @@customer_user2._id, provider: @@provider, person_type: 1)
  @@event = Fabricate(:event, provider: @@provider, variation_ids: [@@provider.workdones.first.prices.first.variation_id],
                    variation_names: ["Dip Boya"]) 
  visit (calendar_provider_path(@@provider.slug)  +"/?provider_id=#{@@provider._id.to_s}")
end  

When(/^I click on an empty cell of scheduler$/) do
  event = Event.new 
  begin 
    page.execute_script("scheduler.showLightbox('#{event._id.to_s}');") 
  rescue 
  end 
end
 

When(/^I select "(.*?)" to "(.*?)" today$/) do |arg1, arg2|
  page.find(:css, "#date1").set DateTime.now.strftime("%d.%m.%Y")
  #page.find(:css, "#date2").set DateTime.now.strftime("%d.%m.%Y")
  page.find(:css, "#time1").set arg1
  page.find(:css, "#time2").set arg2
end

 When(/^I select "(.*?)" variation as service$/) do |arg1|
  sleep 1
  page.all(:css, ".select2-choices")[0].click 
  page.all(:css, '.select2-result-label').find(arg1)
  page.all(:css, '.select2-result-label')[3].click 
end
 
When(/^I select customer "(.*?)"$/) do |arg1|
  page.all(:css, ".select2-choice.select2-default")[0].click
   page.all(:css, '.select2-result-label').find(arg1) 
  page.all(:css, '.select2-result-label')[0].click 
end

When(/^I enter "(.*?)" as reservation description$/) do |arg1| 
 fill_in('event_text', :with=>arg1)
end 

When(/^I submit reservation$/) do
  click_button("save_event")
end

Then(/^I should see a new event between "(.*?)" and "(.*?)"$/) do |arg1, arg2|
  page.should have_content("#{arg1} - #{arg2}")
end 

Then(/^I should see it's description "(.*?)"$/) do |arg1|
  page.should have_content(arg1)
end

Then(/^I should see it's customer "(.*?)"$/) do |arg1|
 page.should have_content(arg1)
end 

Then(/^I should see its category and variation "(.*?)"$/) do |arg1|
  page.should have_content(arg1)
end


When(/^I click on an event$/) do
# page.execute_script("showModal('#{@@event._id.to_s}');")  
 #to-do
end

When(/^I add service "(.*?)"$/) do |arg1|
  #to-do
end

Then(/^I should see updated event between "(.*?)" and "(.*?)"$/) do |arg1, arg2|
 #to-do
end

Then(/^I should see it's staff "(.*?)"$/) do |arg1|
  pending # express the regexp above with the code you wish you had
end


When(/^I select "(.*?)" to block$/) do |arg1|
  click_link("Bu Zamanı Kapat")
  page.all(:css, ".select2-choices")[1].click 
  page.all(:css, '.select2-result-label').find(arg1)
  page.all(:css, '.select2-result-label')[4].click 
end

When(/^I enter reason "(.*?)"$/) do |arg1|
  page.find(:css, "#date1").set DateTime.now.strftime("%d.%m.%Y")
  page.find(:css, "#date2").set DateTime.now.strftime("%d.%m.%Y")
  page.find(:css, "#time1").set arg1
  page.find(:css, "#time2").set arg2
  page.find(:css, "#block_reason").set arg3
  click_button("save_event")
end

When(/^I submit blocks$/) do
  pending # express the regexp above with the code you wish you had
end

When(/^I should see blocked "(.*?)" service with reason "(.*?)" on scheduler$/) do |arg1, arg2|
  page.should have_content arg1
  page.should have_content arg2
end

