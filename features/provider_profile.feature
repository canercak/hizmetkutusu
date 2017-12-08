
@omniauth_test 
Feature: User registers as a service provider
	Scenario: User with valid info registers as a provider first time
		Given I am signed in with provider Facebook
		And I am a user
		And I am on my homepage
		And I don't have any other service providers
		When I click on button to become service provider
	  And I enter valid officialname
		And I select my services
		And I enter description
		And I select my photos
		And I enter valid office phone 
		And I enter mobile phone 
		And I enter email
		And I select my address
		And I enter valid address
		And I select personal business
		And I enter social media addresses
		And I enter my name
		And I enter my pin
		And I select my work hours
		And I select my certificates
		And I submit the form
		# And I confirm my mobile phone
		Then I should be on my profile page
		And I should see my registered details
		And provider should receive an email
		And provider should receive an sms
 


 # 	Scenario: Provider registers a new provider with the same phone without confirming
	# 	Given I am signed in with provider "Facebook"
	# 	And I am a provider
	# 	And I am on my homepage
	# 	When I click on button to become service provider
	# 	And I enter valid officialname
	# 	And I select my services
	# 	And I enter a valid description
	# 	And I select my photos
	# 	And I enter valid mobile phone "(0532)2814785"
	# 	And I enter valid email 
	# 	And I select my address
	# 	And I enter valid address
	# 	And I select personal business
	# 	And I enter my name
	# 	And I enter my pin
	# 	And I select my work hours
	# 	And I select my certificates
	# 	And I submit the form
	# 	Then I should be on my profile page
	# 	And I should see my registered details
	# 	And provider should receive an email
	# 	And provider should receive an sms
 

	# Scenario: Provider updates his mobile phone
	# 	Given I am a provider
	# 	And I am on my profile page
	# 	When I click on button to edit my profile
	# 	And I select my address
	# 	And I change my phone number with "(0512) 2814786" 
	# 	And I submit the form
	# 	And I confirm my mobile phone
	# 	Then my profile should be updated
	# 	And I should be on my profile page

	# Scenario: Provider updates his weekly work hours
	# 	Given I am a provider
	# 	And I am on my profile page
	# 	When I click on button to edit my profile
	# 	And I select day "5" as work day
	# 	And I change start hour to "12:00"
	# 	And I change end hour to "14:00"
	# 	And I submit form
	# 	Then my profile should be updated
	# 	And I should be on my profile page
 

 # 