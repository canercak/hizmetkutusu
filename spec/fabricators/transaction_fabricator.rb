 
Fabricator(:transaction) do
  user {Fabricate(:user)}
  transaction  {Fabricate(:transaction)}
  payment_method_token { "abcd"}
  transaction_token { "abcd"}
  amount {1234}
  type {1}  
  field "done_by" 
end
 