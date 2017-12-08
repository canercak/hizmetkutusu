class Reservation
  include Mongoid::Document
  include Mongoid::MoneyField
  
  embedded_in :provider
  embeds_one :payment


  money_field :total_price, required: true, default_currency: "TRY"
  field :price_ids, :type => Array
  field :start_date, :type =>DateTime 
  field :end_date, :type =>DateTime 
  field :status, :type =>Integer 
  field :staff_ids, :type=>Array
  field :customer_originated, :type=> Boolean
  field :description
  field :quote_id
  field :user_id
  field :location
  field :variation_names

  def make(quote,prices_array, date, staff_ids, status ) 
    self.quote_id = quote._id
    self.user_id = quote.user._id
    self.location = quote.location
    self.price_ids = prices_array
    self.start_date =  date[0]
    self.end_date = date[1]
    self.staff_ids = staff_ids
    self.status = status
    self.total_price = Price.sum_prices(self.provider, prices_array)
    self.save! 
  end 


  def self.range_from_start(date)
    res_date = nil
    if date.present? 
      d = Time.zone.parse(date)
      res_date = [d, d+2.hours]
    end
    return res_date 
  end
 
  def self.match_personel(provider,variation_ids, staff_ids,event_validate)
     matched = Hash.new
     matched[:personel] = true
     matched[:event_validate] = event_validate
     prices =  provider.workdones.map{|w| w.prices.map{|p| p if (variation_ids.include? p.variation_id)}}.reduce(:+).compact
     prices.each do |price|
      if (price.staff_ids & staff_ids).empty? 
        matched[:personel] =false
        matched[:category] = Category.find(price.workdone.category_id).title 
      end
     end
     return matched
  end

  def self.get_invalid_blocks(provider,category_ids,price_ids,staff_id,date,block_id, reservation_id)  
 
    half_hours = ApplicationController.helpers.calculate_half_hours(date)
    category_blocks = provider.blocked_hours.where(:category_id.in=> category_ids,:staff_ids=> staff_id,:_id.ne=>block_id)
    same_block = category_blocks.map {|b| b if (b.start_date == date[0] && b.end_date == date[1])}.compact
    event_blocks = provider.reservations.where(:price_ids.in=>price_ids, :staff_ids=>staff_id, :_id.ne=>reservation_id)  
    same_event = event_blocks.map {|b| b if (b.start_date == date[0] && b.end_date == date[1])}.compact 
    blocks = Array.new
    events = Array.new
    invalid = Hash.new
    unless (same_block.present? || same_event.present?)  
      blocks = ApplicationController.helpers.map_blocks_with_hours(category_blocks, half_hours)
      events = ApplicationController.helpers.map_blocks_with_hours(event_blocks, half_hours)
      if blocks.present? && events.blank?
        invalid[:invalid_title] = ApplicationController.helpers.get_titles(category_ids, blocks, "")
        invalid[:invalid] = "block"
        invalid[:invalid_name] = User.find(staff_id).name
      elsif blocks.blank? && events.present? 
        invalid[:invalid_title] = ApplicationController.helpers.get_titles(category_ids, "", events)
        invalid[:invalid] =  "event"
        invalid[:invalid_name] = User.find(staff_id).name
      elsif blocks.present? && events.present?
        invalid[:invalid_title] = ApplicationController.helpers.get_titles(category_ids, blocks, events)
        invalid[:invalid] =  "both"
        invalid[:invalid_name] =User.find(staff_id).name
      else
        invalid[:invalid] = ""
      end 
    else
      if blocks.present?
        invalid[:invalid] = "block"
      else
        invalid[:invalid] = "event"
      end 
    end
    return invalid
  end
 


end
   