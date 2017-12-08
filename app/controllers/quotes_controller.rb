# encoding: UTF-8
class QuotesController < ApplicationController
  include ApplicationHelper
  include QuotesHelper 
  include UsersHelper
  include ReferencesHelper

  before_filter :require_login, only: [:show, :create, :index]  
  respond_to :html, :json
 
  def getaddress 

    lastaddress = Hash.new
       if current_user.present? && current_user.quotes.present?
      last_quote = current_user.quotes.last
      lastaddress[:location] = last_quote.location.to_s.split.map {|x| x.to_f}
      lastaddress[:address] = last_quote.customer_address
    else
      lastaddress = get_cookie_address(cookies)
    end 
    data = {:location => lastaddress[:location], :customer_address => lastaddress[:address]}
    respond_to do |format|
      format.json  { render :json => data}
    end
  end

 
  def providers
    @providers = @user.providers.desc :created_at
  end
 
  def landing_direct 
    clear_quote_session
    address = get_cookie_address(cookies)
    session[:variation_id] = Moped::BSON::ObjectId.from_string(params[:variation_id])
    session[:variation_text] = params[:variation_text]
    session[:location] = address[:location]
    session[:customer_address] = address[:address]
    session[:query_date] = Time.zone.now 
    data = Hash.new
    data[:path] = new_quote_path
    respond_to do |format|
      format.json  { render :json => data}
    end
  end
  
  def user_prices
    provider = Provider.find(params[:provider_id])
    prices = provider.workdones.map{|w|  w.prices }
    selected_price = Hash.new {|h, k| h[k] = ''}
    user_prices = Hash.new {|h, k| h[k] = ''}
    array = []

    prices.each do |price| 
       category = Category.find_categories([price[0].variation_id])[0]
       if !user_prices.has_key? "#{category.ancestors[1]}"
          user_prices["#{category.ancestors[1]}"] = []
       end
    end 
    prices.each do |price|
      price.each do |p| 
        category = Category.find_categories([price[0].variation_id])[0]
          selected_price[:officialname] = provider.officialname
          selected_price[:price_id] =  Moped::BSON::ObjectId.from_string(params[:price_id])
        if  user_prices.has_key? category.ancestors[1]
          array << [(category.ancestors[2] + ": " + category.title),
                   p._id, 
                   category.business_function.variations.find(p.variation_id).variation,
                   remove_trailing(p.price)]
           user_prices["#{category.ancestors[1]}"] << array
        end
        array = []
      end 
    end
 
    @user_prices = [selected_price,user_prices]
    return @user_prices
  end 

  def new 
    @quote = Quote.new  
    if session[:variation_id].present?
      @quote.variation_id = [session[:variation_id]]
      @quote.location = session[:location]
      @quote.query_date = session[:query_date]
      @quote.variation_text =  session[:variation_text] 
      @quote.customer_address =  session[:customer_address] 
    end  
  end

  def index
    @quotes = Quote.includes(:user).all 
  end

  def show 
    @quote = Quote.find params[:id]
    @conversation = @quote.conversations.find_or_initialize_by(user_ids: [current_user.id, @quote.user.id]) if current_user
    @latest_providers = Provider.includes(:user).all      
    @provider = @quote.provider
    @reference = @provider.references.find_by(:quote_id=>@quote._id)
    @category = Category.find_categories(@quote.variation_id)[0]
    @variation = @category.parent + ": " + @category.title + " - "+ @category.business_function.variations.find(@quote.variation_id[0]).variation 
    @reservation = @quote.provider.reservations.where(:quote_id=>@quote._id).to_a.first
    session[:redirect_to] = quote_path(@quote) unless logged_in? 
    @conversation = Conversation.find_by(:conversable_id => @quote._id)
  end 

  def getselectedproviders    
     id = params[:id]
     @quote = find_quote id         
    i = 0   
    while i < 3  do
      @quote.providers[i].location[1] =  @quote.latitude  
      @quote.providers[i].location[0] =  @quote.longitude
      i +=1
    end
    @json1 =  @quote.providers
    respond_to do |format|
      format.json  { render :json => @json1}
    end
  end

  def create 
    quote = current_user.quotes.new 
    quote.location = [params[:longitude].to_f, params[:latitude].to_f]
    quote.customer_address = params[:customer_address]
    quote.share_on_facebook_timeline = params[:share_on_facebook_timeline]
    quote.variation_id =  [Moped::BSON::ObjectId.from_string(quote_params[:variation_id])] 
    reservation_date = Reservation.range_from_start(params[:reservation_date])
    prices_array = params[:selected_prices].split(",").map {|p| Moped::BSON::ObjectId.from_string(p)}
    if quote.save! 
      provider = Provider.find(params[:selected_providers])
      provider.quotes.push(quote)
      Workdone.update_scores("customer_reservation", quote, quote.provider, nil)
      quote.process_after_quote(prices_array,reservation_date)
      quote.notify_provider_and_user
      if current_user.phone_verified == false && session[:mobile_verified] == true
        current_user.update_attributes!(:phone_verified=> true, :telephone=> validate_phone(params[:current_phones])) 
        session[:mobile_verified] = false
      end 
      redirect_to quote_path(quote), flash: { success:  t('flash.quotes.success.price_based') } 
    end
  end

  def edit
  end

  def update
  end 

  def destroy
  end
  
 private
  def quote_params
    params.require(:quote).permit(    
      :address,
      :share_on_facebook_timeline,  
      :customer_address,
      :location, 
      :longitude,
      :latitude,
      :selected_providers,
      :provider_details,
      :variation_id,
      :distance,
      :gmaps,
      :uid) 

  end
  
  def set_user_as_current_user
    @user = current_user
  end
  
  

  
  
  
  
  
  
  
end
