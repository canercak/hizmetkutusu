 
class Variation

  include Mongoid::Document
  embedded_in :business_function
  field :variation
  field :base_price 
  field :duration, type: Integer


  def self.find_variation(variation_id) 
    variations = Category.all.to_a.map { |c| c.business_function.variations if c.business_function != nil }.compact
    variation = []
    variations.each do |var|
      var.each do |v| 
        if variation_id.include? v._id
       	  category = Category.find(v.business_function.category._id)
          variation << (category.title + ": " + v.variation)
        end 
      end
    end 
    return variation
  end
 
end
 
