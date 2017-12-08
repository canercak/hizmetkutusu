 
Fabricator(:blocked_hour) do
	provider {Fabricate(:provider)}
  start_date {DateTime.now.beginning_of_day + 8}
  end_date{DateTime.now.beginning_of_day + 12}
  block_reason  {Faker::Lorem.sentence(3) } 
  category_id { [Fabricate(:category)._id]}
  staff_ids 
end
 