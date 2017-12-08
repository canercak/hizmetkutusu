 
Fabricator(:payment) do
  reservation {Fabricate(:reservation)}
  credit_card {Fabricate(:credit_card)}
  transaction {Fabricate(:transaction)}
  price {1234}
  accepted {false}
 
end
 