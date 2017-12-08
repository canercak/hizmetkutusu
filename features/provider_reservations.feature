# Feature: Provider Reservations
# 	Scenario: provider blocks hours of a service he is offering
# 		Given I am a provider
# 		And I am on my reservations page
# 		When I click on an empty cell of scheduler
# 		And I select "14:00" to "18:00" today  
# 		And I select "Dip Boya" service to block
# 		And I select "All Personel" to block
# 		And I enter reason "for test purposes"  
# 		And I submit blocks
# 		And I should see blocked "Dip Boya" service with reason "for test purposes" on scheduler

# 	Scenario: provider adds his own reservation
# 		Given I am a provider
# 		And I am on my reservations page
# 		When I click on an empty cell of scheduler
# 		And I select "Dip Boya: 1 Uygulama Kısa Saç İçin" variation as service
# 		And I select "14:00" to "15:15" today
# 		And I select customer "John Warwick"
# 		And I enter "reservation for test purposes" as reservation description
# 		And I submit reservation
# 		Then I should see a new event between "14:00" and "15:15"
# 		And I should see it's description "reservation for test purposes"
# 		And I should see it's customer "John Warwick"
# 		And I should see its category and variation "Dip Boya: 1 Uygulama Kısa Saç İçin" 

# 	Scenario: provider edits his own reservation
# 		Given I am a provider
# 		And I am on my reservations page
# 		When I click on an event
# 		And I add service "Kirpik"
# 		And I select "15:00" to "16:15" today
# 		And I select customer "Alison Birgade"
# 		And I enter "reservation update for test purposes" as reservation description
# 		And I submit reservation
# 		Then I should see updated event between "15:00" and "16:15"
# 		And I should see it's description "reservation update for test purposes"
# 		And I should see it's customer "Alison Birgade"
# 		And I should see its category and variation "Kirpik"

 
# 	Scenario: provider adds staff member for reservation
# 		Given I am a provider
# 		And I am on my reservations page
# 		When I click on an event
# 		And I add service "Kirpik"
# 		And I select "15:00" to "16:15" today
# 		And I select customer "Alison Birgade"
# 		And I enter "reservation update for test purposes" as reservation description
# 		And I select staff "John Miller"
# 		And I submit reservation
# 		Then I should see updated event between "15:00" and "16:15"
# 		And I should see it's description "reservation update for test purposes"
# 		And I should see it's customer "Alison Birgade"
# 		And I should see it's staff "John Miller"
# 		And I should see its category and variation "Kirpik" 
		
# 	Scenario: provider cannot add reservation on a blocked date
# 		Given I am a provider
# 		And I am on my reservations page
# 		And I have service "Kirpik" blocked on "15:00" to "16:00" today  
# 		When I add new event
# 		And I add service "Kirpik"
# 		And I select "14:00" to "17:00" today
# 		And I select customer "Alison Birgade"
# 		And I enter "reservation update for test purposes" as reservation description
# 		And I select staff "John Miller"
# 		And I submit reservation
# 		Then reservation should not be saved
# 		And I should get error message about the problem

# 	Scenario: provider cannot add event on a reservation date
# 		Given I am a provider
# 		And I am on my reservations page
# 		And I have service "Kirpik" reservation on "15:00" to "16:00" today  
# 		When I add new event
# 		And I add service "Kirpik"
# 		And I select "14:00" to "17:00" today
# 		And I select staff "John Miller"
# 		And I select customer "Alison Birgade"
# 		And I enter "reservation update for test purposes" as reservation description 
# 		And I submit reservation
# 		Then reservation should not be saved
# 		And I should get error message about the problem
