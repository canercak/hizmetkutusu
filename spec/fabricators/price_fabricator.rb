Fabricator(:price) do 
  workdone
  variation_id  
  price {45}
  discount {5} 
  duration {60}
  staff_ids {[Fabricate(:user)._id]} 
end