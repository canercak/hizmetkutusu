  class Workdone
  include Mongoid::Document 
  embedded_in :provider  
  embeds_many :prices
  index "prices.variation_id" => 1
  index "prices.price" => 1
  field :workdonecount, type: Integer, default: 0
  field :quotegivencount, type: Integer, default: 0
  field :category_id
  field :rating, type: Integer, default: 0 
  field :give_price, type: Boolean, default: true
  attr_accessor :price0,:price1,:price2,:price3, :discount0, :discount1, :discount2,:discount3, 
                :duration0, :duration1, :duration2, :duration3, :duration4, :duration5, :duration6, :duration7, :duration8, :duration9, :duration10, :duration11, :duration12, :duration13, :duration14,
                 :duration15, :duration16, :duration17, :duration18, :duration19, :duration20, :duration21, :duration22, :duration23, :duration24, :duration25, :duration26,
                :staff_ids0, :staff_ids1, :staff_ids2, :staff_ids3, :staff_ids4, :staff_ids5, :staff_ids6 , :staff_ids7 , :staff_ids8 , :staff_ids9 , :staff_ids10  , :staff_ids11  , :staff_ids12   


  def self.update_prices(provider, params)
    saved = true
    params.keys.each_with_index do |id, index|
      workdone = provider.workdones.find(id)
      if params[id]["give_price"]== "1"     
        workdone.give_price = true
      else
        workdone.give_price = false
      end
      if workdone.save!
        workdone.prices.each_with_index do |price,index| 
          p = params[id]["price#{index}"]
          d = params[id]["discount#{index}"]
          x = params[id]["duration#{index}"]
          y = params[id]["staff_ids#{index}"]
          price.price = p.to_f
          price.discount =d.to_i
          price.duration = x.to_i#Duration.new(:minutes => x)
          y.delete("")
          price.staff_ids = y.map {|v| BSON::ObjectId.from_string(v)}
          unless price.save!
            saved = false            
          end
        end 
      else
        saved = false 
      end
    end
    return saved
  end 

  protected
  def self.update_scores(type, quote, provider, rating)
    workdone=quote.provider.workdones.where(:"prices.variation_id".in=>quote.variation_id).to_a.first
    if type == "customer_reservation"
      self.update_user_score(quote.user, 5)
      self.update_provider_score(quote, workdone, 10, false)
    elsif type == "customer_rating_down"
      self.update_provider_rating(quote, workdone, rating, false)
    elsif type == "customer_rating_up"
      self.update_provider_rating(quote, workdone, rating, true)
    elsif type == "customer_done"
      self.update_user_score(quote.user, 5)
      self.update_provider_score(quote, workdone, 10, true)
    elsif type == "customer_cancel"
      self.update_user_score(quote.user, 5)
      self.update_provider_score(quote, workdone, -10, false)
    elsif type == "provider_reservation"
      self.update_user_score(quote.user, 1)
      self.update_provider_score(quote, workdone, 2, false)
    elsif type == "provider_done"
      self.update_user_score(quote.user, 2)
      self.update_provider_score(quote, workdone, 4, true)
    elsif type == "provider_cancel"
      self.update_user_score(quote.user, -1)
      self.update_provider_score(quote, workdone, -2, false)
    elsif type == "app_verify"
      self.update_provider_overall(provider, 100)
    elsif type == "app_unverify"
      self.update_provider_overall(provider, -100)
    end
  end

  def self.update_user_score(user,amount)
    score = user.score + amount
    user.score =  (score > 0 ? score : 0)
    user.save!
  end

  def self.update_provider_overall(provider,amount)
    score = provider.overall_score + amount
    provider.overall_score = (score > 0 ? score : 0)
    provider.save!
  end

  def self.update_provider_score(quote,workdone,amount, done) 
    workdone.quotegivencount = workdone.quotegivencount + 1
    score = quote.provider.overall_score + amount 
    quote.provider.overall_score = (score > 0 ? score : 0)
    if done == true
      quote.provider.overall_quote_done = quote.provider.overall_quote_done + 1
    else
      if amount > 0
        quote.provider.overall_quote_given = quote.provider.overall_quote_given + 1
      else
        quote.provider.overall_quote_given = quote.provider.overall_quote_given - 1
      end
    end 
    workdone.save! 
  end 

  def self.update_provider_rating(quote, workdone, rating, add) 
    score_to_add = ApplicationController.helpers.calculate_score(rating)
    score = (add == true ? quote.provider.overall_score + score_to_add :  quote.provider.overall_score - score_to_add)
    quote.provider.overall_score =  (score > 0 ? score : 0)
    score2 = (add == true ? workdone.rating + score_to_add : workdone.rating - score_to_add)  
    workdone.rating =  (score2 > 0 ? score2 : 0)
    workdone.save! 
  end
 
end
