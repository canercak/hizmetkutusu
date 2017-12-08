# Feature: Provider Customers
#  	Scenario: provider updates how long a service takes to finish
# 		Given I am a provider
# 		And I am on my prices page
# 		And I see  "Dip Boya" and "1 Uygulama Kısa Saç İçin" with its price "45"
# 		And I see its hours "Onehr"
# 		When I change its hours to "30min"
# 		And I submit price form
# 		Then hours of should be updated to "30min"

# 	Scenario:provider updates staff members responsible from service variations
# 		Given I am a provider
# 		And I have "Hendy Mollison" and "Candy Bllson" as my staff members
# 		And I am on my prices page
# 		And I see  "Dip Boya" and "1 Uygulama Kısa Saç İçin" with its price "45"
# 		And I see my name as the staff member
# 		When I select "Hendy Mollison" and "Candy Bllson" as staff members 
# 		And I submit price form
# 		Then "Hendy Mollison" and "Candy Bllson" shoudl be staff members
#  