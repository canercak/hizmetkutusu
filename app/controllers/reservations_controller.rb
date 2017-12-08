class ReservationsController < ApplicationController
  before_filter :require_login 
  include ReservationsHelper
  include ProvidersHelper
 

  def cancel_reservation
 
    @quote = Quote.find(params[:id]) 
    if @quote.reservations.first.update_attributes!(cancelled: true)
      redirect_to quote_path(@quote), flash: { success: t('flash.quotes.success.cancel_reservation') }
    else
      redirect_to quote_path(@quote), flash: { error: t('flash.quotes.error.cancel_reservation') }
    end
  end


 def get_price
    price = 0  
    if params[:price_ids].first.present?
      provider = Provider.find(params[:provider_id])
      price_ids = params[:price_ids].map{ |v| Moped::BSON::ObjectId.from_string(v)}  
      price = calculate_price(provider,price_ids)
    end
    respond_to do |format|
      format.json {render :json => price}
    end
  end

  def provider_all
    @@provider = Provider.find(params[:id])
    categories = Category.where(:_id.in =>@@provider.workdones.to_a.map { |val| val.category_id})
    data = Category.list_category_prices(@@provider,categories)
    respond_to do |format|
      format.json  {render :json => data}
    end
  end

  def update_price 
    price_id = Moped::BSON::ObjectId.from_string(params[:selected_val])
    selected_prices =  @@provider.workdones.find_by(:"prices._id"=>price_id).prices.map(&:_id) 
    current_prices=  params[:current_val].split(",").map {|v| Moped::BSON::ObjectId.from_string(v)} 
    new_prices = []
    current_prices.each do |price|
      unless selected_prices.include? price
        new_prices << price
      end
    end
    new_prices.push(price_id)
    respond_to do |format|
      format.json  {render :json => new_prices}
    end 
  end


  def manage_blocks
    current=  params[:current_val].split(",").map {|v| Moped::BSON::ObjectId.from_string(v)} 
    selected = Category.find(params[:selected_val])
    cats = Category.where(:ancestors=> selected.title).map(&:_id) 
    new_cats = [selected._id.to_s]
    current.each do |cur|
      unless cats.include? cur 
        new_cats << cur
      end
    end 
    respond_to do |format|
      format.json  {render :json => new_cats}
    end 
  end

  def match_personel
    staff_ids = params[:staff_ids].split(",").map {|v| Moped::BSON::ObjectId.from_string(v)}
    category_ids =  params[:category_ids].present? ? params[:category_ids].split(",").map {|v| Moped::BSON::ObjectId.from_string(v)} : nil
    price_ids =  params[:price_ids].present? ? params[:price_ids].split(",").map {|v| Moped::BSON::ObjectId.from_string(v)} : nil
    variation_ids = nil
    event_validate = true
    if category_ids.blank? 
      variation_ids = Price.get_variation(@@provider,price_ids)
    else
      variation_ids = Category.find_variations(category_ids)
      event_validate = false
    end 
    matched = Reservation.match_personel(@@provider,variation_ids, staff_ids ,event_validate)
    respond_to do |format|
      format.json  {render :json => matched}
    end  
  end

  def check_block_valid
    @@provider = Provider.find(params[:provider_id]) 
    block_id = params[:block_id].present? ? Moped::BSON::ObjectId.from_string(params[:block_id]) : nil 
    reservation_id = params[:reservation_id].present? ? Moped::BSON::ObjectId.from_string(params[:reservation_id]) : nil
    date = calendar_dates(params[:date], params[:start], params[:end])
    category_ids =  params[:category_ids].present? ? params[:category_ids].split(",").map {|v| Moped::BSON::ObjectId.from_string(v)} : nil
    price_ids =  params[:price_ids].present? ? params[:price_ids].split(",").map {|v| Moped::BSON::ObjectId.from_string(v)} : nil
    staff_id = nil
    event_staff = params[:event_staff].present? ? [Moped::BSON::ObjectId.from_string(params[:event_staff])] : []
    block_staff = params[:block_staff].present? ? [Moped::BSON::ObjectId.from_string(params[:block_staff])] : []
    if category_ids.present?
      staff_id = params[:selected_val] != "0000" ? Moped::BSON::ObjectId.from_string(params[:selected_val]) : Price.allstaff_from_categories(@@provider,category_ids)
      variation_ids = Category.find_variations(category_ids)
    else
      staff_id = Moped::BSON::ObjectId.from_string(params[:selected_val])
      variation_ids = @@provider.workdones.map{|w| w.prices.map{|p| p.variation_id if price_ids.include?(p._id)}}.reduce(:+).compact
      category_ids = Category.find_categories(variation_ids).map(&:_id)
    end 
    invalid = Reservation.get_invalid_blocks(@@provider, category_ids, price_ids, staff_id, date,block_id,reservation_id) 
    respond_to do |format|
      format.json  {render :json => invalid}
    end
  end

  def delete_block
    block = @@provider.blocked_hours.find(params[:block_id])
    respond_to do |format|
      format.json  {render :json => block.destroy}
    end
  end



  def check_blocked  
    provider = Provider.find(params[:provider_id])
    category_id =  Moped::BSON::ObjectId.from_string(params[:category_id])
    staff_ids = params[:staff_id] != "0000" ? [Moped::BSON::ObjectId.from_string(params[:staff_id])] : provider.workdones.map{|w| w.prices.map{|p| p.staff_ids}}.reduce(:+).reduce(:+).uniq
    date = Time.zone.parse(params[:date]) 
    bh_active = provider.business_hours[ApplicationController.helpers.business_hour_from_wday(date.wday)]["isActive"]
    related_categories = Category.find_related(category_id)
    data = provider.blocked_hours.where(:category_id.in=> related_categories, :staff_ids.in=>staff_ids, 
                                        :start_date.lte =>date,
                                        :end_date.gte => date+1.hours).to_a  
    if data.present? && bh_active == true  
      category_ids = data.map(&:category_id).reduce(:+)
      all_staff = Price.allstaff_from_categories(provider,category_ids)
      staff_ids = (all_staff == data[0].staff_ids) ? "0000" :  data[0].staff_ids
      data = [{:category_ids=> category_ids, 
               :staff_ids=> staff_ids ,
               :block_reason=> data[0].block_reason,
               :start_date=> data[0].start_date, 
               :end_date=> data[0].end_date,
               :block_id=>data[0]._id }] 
    end
    if data.blank? && bh_active == false
      data = [{:start_date=> (date.beginning_of_day + 11.hours), 
               :end_date=> date.beginning_of_day + 12.hours }]      
    end
    respond_to do |format|
      format.json  {render :json => data}
    end
  end


  def events_personel
    price_ids = params[:price_ids].map {|v| Moped::BSON::ObjectId.from_string(v)}
    variation_ids = Price.get_variation(@@provider,price_ids) 
    staff = Customer.staff_from_variations(@@provider,variation_ids)
    data = Jbuilder.encode do |json|
      json.data staff.each do |staff|
        json.id  staff._id
        json.text staff.name
      end
    end 
    respond_to do |format|
      format.json  {render :json => data}
    end 
  end 

  def personels_block 
    category_ids = params[:category_ids].map {|v| Moped::BSON::ObjectId.from_string(v)}
    variation_ids = Category.find_variations(category_ids) 
    staff = Customer.staff_from_variations(@@provider,variation_ids)
    data = Jbuilder.encode do |json|
      json.data [1] do
        json.id "0000"
        json.text "Tüm Personeller"
        json.children  staff.each do |staff|
          json.id  staff._id
          json.text staff.name
        end
      end
    end 
    respond_to do |format|
      format.json  {render :json => data}
    end 
  end

  def personel_list
    @@provider = Provider.find(params[:id])
    staff_ids = @@provider.workdones.map{|w| w.prices.map{|p| p.staff_ids}}.reduce(:+).reduce(:+).uniq
    staff =  User.where(:_id.in=>staff_ids).to_a
    data = Jbuilder.encode do |json|
      json.data [1] do
        json.id "0000"
        json.text "Tüm Personeller"
        json.children  staff.each do |staff|
          json.id  staff._id
          json.text staff.name
        end
      end
    end 
    respond_to do |format|
      format.json  {render :json => data}
    end 
    
  end
  
  def events_block
    @@provider = Provider.find(params[:id])
    staff_ids = (params[:staff_id] == "0000" || params[:staff_id].blank?)  ? @@provider.workdones.map{|w| w.prices.map{|p| p.staff_ids}}.reduce(:+).reduce(:+).uniq :  [Moped::BSON::ObjectId.from_string(params[:staff_id])] 
    workdones =  @@provider.workdones.map{|w| w.prices.map{|p| p.workdone if (!(p.staff_ids & staff_ids).empty? && (p.active = true))}}.reduce(:+).uniq.compact
    categories_array =  workdones.map {|c| c.category_id }
    categories = Category.where(:_id.in => categories_array).order_by(:ancestors.desc) 
    xgrand_parents = categories.map {|a| a.ancestors[0] } & categories.map {|a| a.ancestors[0] }
    grand_parents = categories.map {|a| a.ancestors[1] } & categories.map {|a| a.ancestors[1] }
    parents = categories.map{|c| c.ancestors[2] } & categories.map{|c| c.ancestors[2] }
    childs = categories.map{|c| c.ancestors[3] } & categories.map{|c| c.ancestors[3] }
    babies = categories.to_a.map {|a| a.title}  
    data = Jbuilder.encode do |json|
      json.data xgrand_parents.each do |xgp|
        xgpcat = Category.find_by(:title=>xgp)
        json.id  xgpcat._id
        json.text xgpcat.title
        json.children Category.where(:parent=>xgpcat.title, :title.in=>grand_parents).to_a do |grand_parent| 
          json.id  grand_parent._id
          json.text grand_parent.title
          json.children Category.where(:parent=>grand_parent.title, :title.in=>parents).to_a do |parent| 
            json.id parent._id
            json.text parent.title 
            json.children Category.where(:parent=>parent.title, :title.in=>childs).to_a do |child| 
              json.id child._id
              json.text child.title 
              json.children Category.where(:parent=>child.title, :title.in=>babies).to_a do |baby| 
                json.id baby._id
                json.text baby.title
              end  
            end
          end 
        end
      end
    end
    respond_to do |format|
      format.json  {render :json => data}
    end 
  end

  def load_event 
    reservation = @@provider.reservations.find(params[:reservation_id])
    data= nil
    Jbuilder.encode do |json|
      data = json.array! reservation.to_a do |ev| 
        json.id ev._id 
        json.text ev.description
        json.type ev.status
        json.user_id ev.user_id
        json.staff_ids ev.staff_ids 
        json.prices ev.price_ids
        if ev.status == 1 
           json.types reservation_types[1..1]
        elsif ev.status == 2
          json.types reservation_types[2..2]
        else
          json.types reservation_types 
        end
      end
    end
    respond_to do |format|
      format.json  {render :json => data}
    end
  end
 
  def load_scheduler 

    @@from = Time.zone.parse(params[:from])
    @@to = Time.zone.parse(params[:to])
    @@provider = Provider.find(Moped::BSON::ObjectId.from_string(params[:provider_id]))
    category_ids = params[:category_id].split(",").map {|v| Moped::BSON::ObjectId.from_string(v)}
    variation_ids = Category.find_variations(category_ids)  
    price_ids =  @@provider.workdones.map{|w| w.prices.map{|p| p._id if variation_ids.include?(p.variation_id)}}.reduce(:+).compact
    staff_ids = params[:staff_id] != "0000" ? [Moped::BSON::ObjectId.from_string(params[:staff_id])] : @@provider.workdones.map{|w| w.prices.map{|p| p.staff_ids}}.reduce(:+).reduce(:+).uniq
    @@reservations = @@provider.reservations.where(:price_ids.in=>price_ids,:staff_ids.in=>staff_ids,
                                       :start_date.gte => @@from,
                                       :end_date.lte => @@to) 
    related_categories = Category.find_related(category_ids[0])
    @@blocks = @@provider.blocked_hours.where(:category_id.in=> related_categories,:staff_ids.in=>staff_ids,
                                              :start_date.gte =>@@from,
                                              :end_date.lte => @@to).to_a

    data = Jbuilder.encode do |json|
      json.array! @@reservations.each do |reservation| 
        json.id reservation._id.to_s
        json.text reservation.description
        json.start_date reservation.start_date.in_time_zone.strftime("%d-%m-%Y %H:%M:%S")
        json.end_date reservation.end_date.in_time_zone.strftime("%d-%m-%Y %H:%M:%S")
        json.color set_color(reservation.status, reservation.customer_originated)
        json.type reservation.status
        json.lat  reservation.location[1].to_s 
        json.lng reservation.location[0].to_s 
        json.prices  price_ids
        json.variation_names   reservation.variation_names
        json.staff_ids reservation.staff_ids
      end
    end
    respond_to do |format| 
      format.json {render :json => data} 
    end 
  end

  def get_calendar_range
    provider = Provider.find(params[:provider_id])
    respond_to do |format| 

      format.json {render :json => calendar_range(provider)} 
    end 
  end

  def get_blocked_times 
    provider = Provider.find(params[:provider_id])
    data = calendar_blocked_times(provider) 
    respond_to do |format| 
      format.json {render :json => data.to_json} 
    end 
  end


  def get_user_blocks
    data =  BlockedHour.match_business_hours(@@provider,@@reservations, @@blocks, @@from,@@to )
    respond_to do |format| 
      format.json {render :json => data} 
    end
  end 
 
  def save
    provider = Provider.find(params[:provider_id]) 
    user = User.find(params[:customer])
    staff_ids = params[:personel].split(",").map {|v| Moped::BSON::ObjectId.from_string(v)}
    provider_prices =  params[:prices].split(",").map {|v| Moped::BSON::ObjectId.from_string(v)}
    reservation_date = calendar_dates(params[:date], params[:start], params[:end])
    status = params[:type].to_i
    quote= nil
    reservation = nil
    if params[:reservation_id].present?
      reservation = provider.reservations.where(:_id=>Moped::BSON::ObjectId.from_string(params[:reservation_id])).to_a.first
      quote = Quote.find(reservation.quote_id)
      quote.variation_id = Price.get_variation(provider,provider_prices)
      reservation.description = params[:text]
    else 
      quote = user.quotes.new  
      provider.quotes.push(quote)
      reservation = provider.reservations.build
      reservation.customer_originated = false
      reservation.description = params[:text]
      reservation.variation_names = user.name
      quote.location = provider.location
      quote.customer_address = provider.business_address
      quote.share_on_facebook_timeline = false
      quote.variation_id = Price.get_variation(provider,provider_prices)  
    end
    if quote.save!
      reservation.make(quote,provider_prices,reservation_date, staff_ids, status ) 
      update_status_scores(quote,reservation)
      respond_to do |format| 
        format.json {render :json => provider.reservations.find_by(:quote_id=>quote._id).to_json } 
      end
    end
   end  




 
end
