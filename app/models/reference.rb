class Reference
  include Mongoid::Document
  include Mongoid::Timestamps
  include PublicActivity::Model
  include UsersHelper
  tracked
 
  embedded_in :provider
  #has_one :quote
  attr_accessor :ratehidden

  field :comment
  field :quote_id
  field :user_id
  field :user_image
  field :firstname
  field :rating
  field :category_name
  field :type
  field :day_ago

  validates :comment,length: { maximum: 160 } 
  #validates :rating, presence: true
  
  
  def self.update_reference_by_sms(quote, provider, rating)
    name = quote.user.name.split(' ', 2)
    reference = provider.references.build(rating)
    reference.quote_id = quote.id
    reference.user_image =  "https://graph.facebook.com/#{quote.user.class == User ? quote.user.uid : quote.user}/picture?type=square"
    reference.firstname = name[0] + " " + name[1][0] +"."
    reference.user_id = quote.user.id
    reference.rating = rating.to_i    
    quote = Quote.find reference.quote_id
    reference.category_name=Category.find(quote.category_id).title
    if  reference.save  
      scorechanges = {}
      scorechanges[:rating] = [true, reference.rating.to_i] 
      Workdone.update_scores("customer_rating", quote, quote.provider, scorechanges)
    end
  end
end
