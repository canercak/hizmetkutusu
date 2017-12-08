class Payment
  include Mongoid::Document
  include Mongoid::MoneyField
  
  belongs_to :reservation
  has_one :credit_card
  has_one :transaction

  money_field :price, required: true, default_currency: "TRY"
  field :accepted, :type=>Boolean

end
