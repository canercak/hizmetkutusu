class BusinessFunction
  include Mongoid::Document
  embedded_in :category
  embeds_many :variations
  field :function
  field :category_tree
  field :unit
  field :eco
  field :pto
  field :onsite, :type=> Boolean
end
 
