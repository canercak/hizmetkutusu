 
# Feature: Home page 
# 	Scenario: user with unconfirmed phone makes reservation
# 		Given I am a user
# 		And I am on my homepage
# 		When I fill my address with valid details
# 		And I select a service category
# 		And I select a variation of this service category 
# 		And I press next step button
# 		And I select a price of a provider that offers that service
# 		And I click reserve button
# 		And I select a time
# 		And I click confirm reservation button
# 		And I confirm my phone number
# 		Then my reservation should be made
# 		And providers should be notified about reservation 
# 		And I should be notified 
# 		And I should be able to pay for my reservation

# 	Scenario: user with unconfirmed phone makes quote request
# 		Given I am a user
# 		And I am on my homepage
# 		When I fill my address with valid details
# 		And I select a service category
# 		And I select a variation of this service category 
# 		And I press next step button
# 		And I select quote request of a provider that offers that service
# 		And I select quote request of another provider that offers that service
# 		When I click confirm button
# 		And I confirm my phone number
# 		Then my quote request should be made
# 		And providers should be notified about request
# 		And I should be notified 
# 		And I should be able send message to providers
# 		And I should be able send file to providers
 
 
# 	Scenario: user views available hours for service of a provider
# 		Given I am a user
# 		And I am on my homepage
# 		And there is a a provider in the system
# 		And that provider offers "Dip Boya" service
# 		And that provider is available tomorrow between "14:00" and "18:00"
# 		When I fill my address with valid details
# 		And I select "Dip Boya" service category
# 		And I select "1 uygulama Kısa Saç" variation of this service category 
# 		And I press next step button
# 		And I select a price of that provider for "Dip Boya" service
# 		And I click reserve button
# 		Then I should see that that he is only available tomorrow between "14:00" and "18:00"
# 		And I should see that he is unavailable all day today

#   Scenario: reservation gets assigned to the available staff
# 		Given I am a user
# 		And I am on my homepage
# 		And there is a a provider in the system
# 		And that provider offers "Dip Boya" service
# 		And staff "Jane Austen" and "Mark Hampton" does that service
# 		And they are working tomorrow between "09:00" and "18:00"
# 		And staff "Jane Austen" has two reservations between "17:00" and "19:00" 
# 		And staff "Mark Hampton" has reservation between "09:00" and "12:00"
# 		When I fill my address with valid details
# 		And I select "Dip Boya" service category
# 		And I select "1 uygulama Kısa Saç" variation of this service category 
# 		And I press next step button
# 		And I select a price of that provider for "Dip Boya" service
# 		And I reserve tomorrow "15:00"
# 		And I submit form
# 		Then reservation should be assigned to least busy person "Mark Hampton" 
 


#  