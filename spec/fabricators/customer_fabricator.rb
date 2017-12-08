 
Fabricator(:customer) do
	provider { Fabricate(:provider)._id}
	user_id { Fabricate(:user)._id}
  person_type {0}
  address {"6352 sok no 11 Bostanlı - Izmir"}
end
 