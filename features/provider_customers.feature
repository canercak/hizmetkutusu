# Feature: Provider Customers
#  	Scenario: provider without web-access adds a customer who is not in the system
# 		Given I am a provider
# 		And I have not defined my web-access
# 		And I am on new customers page
# 		When I enter phone  "(0532) 2314785" which is not in the system
# 		And I enter email "haleb@gmails.com"
# 		And I enter name "Hale Berry" 		
# 		And I enter address "6352 sok no 17/6 Bostanlı İzmir"
# 		And I select "Customer" type
# 		And I submit customer form
# 		Then I should see saved customer "Hale Berry"  on the list
# 		And customer should get invitation by email
# 		And customer should get invitation by phone

#  	Scenario: provider without web-access adds a customer who is not in the system
# 		Given I am a provider
# 		And I have not defined my web-access
# 		And I am on new customers page
# 		When I enter phone  "(0532) 1314785" which is not in the system
# 		And I enter email "jmlii@gmails.com"
# 		And I enter name "John Miller" 		
# 		And I enter address "6352 sok no 17/6 Bostanlı İzmir"
# 		And I select "Staff Member" type
# 		And I submit customer form
# 		Then I should see saved customer "John Miller"  on the list
# 		And customer should get invitation by email
# 		And customer should get invitation by phone





 
#  