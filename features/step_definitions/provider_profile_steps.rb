When(/^I click on button to become service provider$/) do
  Fabricate(:address) 
  visit new_provider_path 
end

When(/^I enter valid officialname$/) do
  fill_in("provider_officialname", :with=> "Canercak A.Ş.") 
end

When(/^I select my services$/) do 
  page.execute_script("$('#tree').fancytree('getTree').visit(function(node){node.setSelected(true);});")
end

When(/^I enter description$/) do
  fill_in("business_description", :with=> "We are styling hairs and nails") 
end
# script = "$('#file-field').css({opacity: 100, display: 'block'});"
# page.driver.browser.execute_script(script)
# => 
When(/^I select my photos$/) do 
  attach_file('provider_image1', image_to_attach)
 # stub_transloadit!(ProvidersController, example_json)
end

When(/^I enter valid office phone$/) do 
  fill_in("office_phone", :with=>"0232123456")
end

When(/^I enter mobile phone$/) do 
  fill_in("contact_phone", :with=>"05322814785")
end

When(/^I change my phone number with "(.*?)"$/) do |arg1|
  fill_in("contact_phone", :with=>arg1)
end


When(/^I enter email$/) do
  fill_in("provider_business_email", :with=>"canercak@gmail.com")
end

When(/^I select my address$/) do 
  page.find(:css, "#province").find("option[value='Adana']").select_option
  sleep 3
  page.find(:css, "#district").find("option[value='Seyhan']").select_option
  sleep 3
  page.find(:css, "#neigbor").find("option[value='Yağcami']").select_option
  sleep 3
  page.find(:css, "#local").find("option[value='Karasoku Mah.']").select_option
  fill_in("street", :with=>"123 Street")
  fill_in("no_door", :with=>"12")
end


When(/^I enter valid address$/) do
  page.find(:css, "#business_address").set "bostanli mah., izmir, Turkiye"
  page.execute_script("$('#latitude').val('38.456221');") 
  page.execute_script("$('#longitude').val('27.09382789999995');") 
end

When(/^I select personal business$/) do
   page.find(:css, "#provider_business_type").find("option[value='1']").select_option
end 

When(/^I enter social media addresses$/) do
  fill_in("foursquare_data", :with=>"https://foursquare.com/v/key-kuaf%C3%B6r-ve-g%C3%BCzellik-salonu/4fcd142fe4b0131cb4ac0121")
  fill_in("facebook_data", :with=>"https://www.facebook.com/pages/KEY-KUAF%C3%96R/200929789306")
  fill_in("twitter_data", :with=>"https://twitter.com/KeyCoiffeur")
  fill_in("googleplus_data", :with=>"https://plus.google.com/114075694242254283754/posts")
  fill_in("instagram_data", :with=>"http://instagram.com/keykuafor")
end 
When(/^I enter my name$/) do
  expect(page).to have_css("#provider_tax_fullname")
  fill_in("provider_tax_fullname", :with => "Caner Çakmak")
end

When(/^I enter my pin$/) do
  fill_in("provider_tax_pin", :with => "54469534156")
end

When(/^I select my work hours$/) do
  #page.execute_script %Q{ $("a.ui-state-default:contains('17')").trigger("click") }
end

When(/^I select my certificates$/) do
  attach_file('certificate_image1', image_to_attach)
end

When(/^I submit the form$/) do
  page.find(:css, "#form1_submit").click
  sleep 10
end

When(/^I confirm my mobile phone$/) do
  page.find(:css, "#sendverification").click
  sleep 1
  otp = page.find(:css, "#otp").value
  fill_in("verification_code", :with=>otp)  
  page.find(:css, "#verification_code_button").click 
  sleep 5
end

Then(/^I should be on my profile page$/) do 
  expect(page).to have_css(".vcard-fullname.fn")
end

Then(/^I should see my registered details$/) do
  expect(page).to have_content("Canercak A.Ş.")
end

Then(/^provider should receive an email$/) do
  #result = ProviderMailer.registration_email(Provider.first).deliver 
  #expect(result).not_to be_false
end

Then(/^provider should receive an sms$/) do
  #to-do
  #expect(Sms.first).not_to be_nil 
end 

Given(/^I am a provider$/) do
  Fabricate(:address) 
  @@user = User.all.first
  variation = Fabricate(:variation)
  category = variation.business_function.category
  category.save!
  @@provider =  Fabricate(:price, variation_id: variation._id).workdone.provider
  @@provider.workdones.first.update_attributes(:category_id => category._id)
  @@provider.user = User.all.first
  @@phone = "05322814785" # verified phone
  @@provider.business_phone = @@phone
  @@provider.user.telephone= @@phone
  @@provider.save!
  @current_user =  @@provider.user 
  cookie_jar = Capybara.current_session.driver.browser.current_session.instance_variable_get(:@rack_mock_session).cookie_jar
  cookie_jar[:stub_user_id] = @current_user.id 
  expect(@current_user).not_to be_nil
end

Given(/^I don't have any other service providers$/) do
  @@user.providers = nil
end
 

Given(/^I am on my profile page$/) do
  visit  provider_path(@@provider.slug)
end

When(/^I click on button to edit my profile$/) do
   visit edit_provider_path(@@provider.slug)
end

When(/^I change my official name$/) do
  fill_in("provider_officialname", :with=> "Canercak2 A.Ş.") 
end

When(/^I change my address$/) do
  page.find(:css, "#business_address").set "bostanli mah., izmir, Turkiye"
  page.execute_script("$('#latitude').val('38.41');") 
  page.execute_script("$('#longitude').val('27.091');") 
end

When(/^I add a picture$/) do
   attach_file('provider_image2', image_to_attach)
end

When(/^I change my phone number$/) do
  fill_in("contact_phone", :with=>"(0532) 2814786")
end
 
When(/^I change my email$/) do
  fill_in("email", :with=>"canercak2@gmail.com")
end

Then(/^my profile should be updated$/) do
  expect(current_user.providers.first.business_phone).not_to be(@@phone)
end 

When(/^I select day "(.*?)" as work day$/) do |arg1|
   @@wday = arg1.to_i
   page.all(:css, ".dayContainer")[@@wday].click 
end

When(/^I change start hour to "(.*?)"$/) do |arg1|
  page.all(:css, ".dayContainer")[@@wday].first(".operationDayTimeContainer").first(".operationTime.input-group").first(".mini-time.form-control.operationTimeFrom.ui-timepicker-input").set arg1
end

When(/^I change end hour to "(.*?)"$/) do |arg1|
  page.all(:css, ".dayContainer")[@@wday+1].first(".operationDayTimeContainer").first(".operationTime.input-group").first(".mini-time.form-control.operationTimeFrom.ui-timepicker-input").set arg1
end

When(/^I submit form$/) do
 click_button('Update')
end


