 
Fabricator(:reservation) do
  quote 
  #payment { Fabcricate(:payment)}
  total_price {1234}
  price_ids 
  start_date 
  end_date 
  applied {false} 
  cancelled {false} 
end
 