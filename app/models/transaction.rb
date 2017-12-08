class Transaction 
  include Mongoid::Document
  include Mongoid::Timestamps
  
  belongs_to :user
  has_many :transactions
  field :payment_method_token, type: String
  field :transaction_token, type: String
  field :amount, type: Integer
  field :type, type: Integer
  field :done_by


 
end
