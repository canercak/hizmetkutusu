 
class Price
  include Mongoid::Document
 
  embedded_in :workdone 
  field :variation_id   
  field :price, type: Float
  field :discount, type: Integer
  field :duration, type: Integer 
  field :staff_ids, type: Array 
  field :active, type: Boolean, default: true
 

  def self.get_high_lows(variation_id, provider) 
    data = Hash.new 
    data[:center] = provider.location
    data[:variation_id] = variation_id
    data[:radius] = 25
    providers = Provider.matched_providers(data)  
    if providers.blank?
      return nil
    end
    pricearray =  providers.map {|p| p.workdones.map{|w| w.prices.map {|p| p.price if (p.variation_id == variation_id && p.workdone.give_price == true)}}}.reduce(:+).reduce(:+).compact
    if pricearray.present? 
      return [pricearray.min , pricearray.max]
    else
      return nil
    end
  end 

  def self.update_staff(provider, user_id)
    prices = provider.workdones.map{|w| w.prices.map{|p| p }}.reduce(:+)
    prices.each do |price|
      price.staff_ids << user_id
      price.save!
    end
  end

  def self.get_variation_name(variation_id)  
    business_functions = Category.all.map {|c| c.business_function }
    variations = business_functions.map { |bf| bf != nil ? bf.variations : nil} 
    variations.each do |var|
       if var != nil
        var.each do |v|
          if v._id == variation_id
            return v.variation
          end    
        end
      end
    end 
  end


  def self.get_variation(provider,prices_array)
    workdones = provider.workdones.where(:"prices._id".in=>prices_array)
    return  workdones.map{|w| w.prices.map{|p| p.variation_id}}.reduce(:+)
  end

  def self.get_variation_names(provider,prices_array)
    workdones = provider.workdones.where(:"prices._id".in=>prices_array)
    variation_ids = workdones.map{|w| w.prices.map{|p| p.variation_id}}.reduce(:+)
 
    variation_names = Category.map{|c| c.business_function.variations.map{|v| v.variation if variation_ids.include?(v._id)}}.reduce(:+)
    return variation_names
  end

  def self.sum_prices(provider, prices_array)
        workdones = provider.workdones.where(:"prices._id".in=>prices_array)
    return workdones.map{|w| w.prices.map{|p| p.price.to_f}}.reduce(:+).reduce(:+)
  end

  def self.calculate_duration(provider,prices_array)
    workdones = provider.workdones.where(:"prices._id".in=>prices_array)
    total = workdones.map{|w| w.prices.map{|p| p.duration}}.reduce(:+).reduce(:+)
    seconds = total * 60
    return seconds
  end



  def self.allstaff_from_categories(provider,categories)
    workdones = provider.workdones.where(:category_id.in=>categories)
    staff_ids = workdones.map{|w| w.prices.map{|p| p.staff_ids}}.reduce(:+).reduce(:+)
    staff = staff_ids & staff_ids
    return staff
  end
 



end
