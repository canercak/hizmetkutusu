
Given(/^I am a user$/) do
  @@user = Fabricate :user
  @current_user =  @@user 
end

Given(/^I am on my homepage$/) do
  @@variation = Fabricate :variation
  category = @@variation.business_function.category
  @@price = Fabricate(:price, variation_id: @@variation._id)
  @@price_offer1 = Fabricate(:price, variation_id: @@variation._id)
  @@price_offer1.workdone.update_attributes(:give_price=> false, :category_id => category._id)
  @@price_offer2 = Fabricate(:price, variation_id: @@variation._id)
  @@price_offer2.workdone.update_attributes(:give_price=> false, :category_id => category._id) 
end

When(/^I fill my address with valid details$/) do
   page.execute_script("$('#latitude').val('38.456221');") 
   page.execute_script("$('#longitude').val('27.09382789999995');") 
end

When(/^I select a service category$/) do
  page.find(:css, ".select2-choice.select2-default").click 
  page.find(:css, "#s2id_autogen1_search").set @@variation.business_function.category.title
  sleep 3
  page.all(:css, '.select2-result-label')[1].click
end

When(/^I select a variation of this service category$/) do
  page.find(:css, ".select2-choice.select2-default").click
  sleep 3 
  page.all(:css, '.select2-result-label')[0].click
end

When(/^I press next step button$/) do
  page.find(:css, "#wizard-next-step-button").click
end

When(/^I select a price of a provider that offers that service$/) do
  sleep 2
  expect(page).to have_content(@@price.workdone.provider.officialname)
  expect(page).to have_content(@@price.price.to_i.to_s + " TL")
  page.all(:css, ".btn.clearfix.displayAsButton.btn-danger")[0].click
end

When(/^I click reserve button$/) do
  page.find(:css, "#new_quote_submit").click
end

When(/^I select a time$/) do
 sleep 2
 page.all(:css, '.day')[2].click
 sleep 2
 page.all(:css, '.btn.btn-default.button.button-cal.time-button')[4].click
end

When(/^I click confirm reservation button$/) do
  page.find(:css, "#reserve_booking").click
end


When(/^I confirm my phone number$/) do
  fill_in("verification_phone", :with=>"(0532) 2814785")
  page.find(:css, "#sendverification").click
  sleep 1
  otp = page.find(:css, "#otp").value
  fill_in("verification_code", :with=>otp)  
  page.find(:css, "#verification_code_button").click 
end

Then(/^my reservation should be made$/) do
  sleep 2
  expect(Quote.first.reservations).not_to be(nil) 
end 

Then(/^I should be able to pay for my reservation$/) do
  page.should have_css("#pay_quote")
end

Then(/^providers should be notified about reservation$/) do
  sleep 2
  expect(page.find(:css, "#reservation_made_#{Quote.first.providers.first._id.to_s}")).not_to be_nil
  #page.find(:css, "#reservation_made_#{Quote.first.providers.first._id.to_s}")
end
Then(/^providers should be notified about request$/) do
  sleep 2
  page.should have_css("#request_sent_#{Quote.first.providers[0]._id.to_s}")
  page.should have_css("#request_sent_#{Quote.first.providers[1]._id.to_s}")
end

Then(/^I should be notified$/) do
  page.should have_css("#request_sent_user#{Quote.first.user_id.to_s}")
end

When(/^I select quote request of a provider that offers that service$/) do
  sleep 2
  expect(page).to have_content(@@price_offer1.workdone.provider.officialname)
  page.all(:css, ".btn.clearfix.displayAsButton.btn-danger")[1].click
end

When(/^I select quote request of another provider that offers that service$/) do
  sleep 2
  expect(page).to have_content(@@price_offer2.workdone.provider.officialname)
  page.all(:css, ".btn.clearfix.displayAsButton.btn-danger")[1].click
end

When(/^I click confirm button$/) do
  page.find(:css, "#new_quote_submit").click
end

Then(/^my quote request should be made$/) do
sleep 2 
   expect(Quote.first.offers).not_to be_nil  
end
 
Then(/^I should be able send message to providers$/) do
  fill_in("conversation_message_body", :with=>"hello providers")
  page.find(:css, "#send_message").click
  sleep 2
  page.should have_content("hello providers")  
end

Then(/^I should be able send file to providers$/) do
  expect(page).to have_css("#send_file")
end 

Given(/^there is a a provider in the system$/) do
 variation =  Fabricate(:variation)  
 @@price = Fabricate(:price, variation_id: variation._id)
 @@provider = @@price.workdone.provider
 @@category_id = variation.business_function.category._id
 @@provider.workdones.first.category_id = @@category_id
 @@provider.save
 expect(@@price.workdone.provider).not_to be_nil
end

Given(/^that provider offers "(.*?)" service$/) do |arg1|
  expect(Category.find(@@provider.workdones.first.category_id).title).to eq arg1
end

Given(/^that provider is available tomorrow between "(.*?)" and "(.*?)"$/) do |arg1, arg2|
  start_d = Time.parse(arg1).hour
  end_d = Time.parse(arg2).hour
  blocked = @@provider.blocked_hours.where(:category_id.in=>[@@category_id],
             :start_date.gte => start_d,
             :end_date.lte => end_d) 
  reserved = @@provider.quotes.where(:"reservations.price_ids".in => [@@price._id],
                  :"reservations.start_date".gte => start_d, 
                  :"reservations.end_date".lte => end_d).map{|q| q.reservations[0]}
  expect(blocked.to_a.count).to eq 0 
  expect(reserved.to_a.count).to eq 0 
end 


When(/^I select "(.*?)" service category$/) do |arg1|
  page.find(:css, ".select2-choice.select2-default").click 
  page.find(:css, "#s2id_autogen1_search").set @@variation.business_function.category.title
  sleep 3
  page.all(:css, '.select2-result-label')[1].click

end

When(/^I select "(.*?)" variation of this service category$/) do |arg1| 
  page.find(:css, ".select2-choice.select2-default").click
  sleep 3 
  page.all(:css, '.select2-result-label')[0].click  
end 

When(/^I press next step button$/) do
  page.find(:css, "#wizard-next-step-button").click
end 


When(/^I select a price of that provider for "(.*?)" service$/) do |arg1|
  #todo ater customer
end

Then(/^I should see that that he is only available tomorrow between "(.*?)" and "(.*?)"$/) do |arg1, arg2|
    #todo ater customer
end

Then(/^I should see that he is unavailable all day today$/) do
   #todo ater customer
end


