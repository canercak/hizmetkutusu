# encoding: UTF-8 
  class ProvidersController < ApplicationController 
   include UsersHelper
   include ProvidersHelper
   include WorkdonesHelper
   include QuotesHelper
   include Transloadit::Rails::ParamsDecoder
   include ActionView::Helpers::DateHelper
   require 'action_view'
   require 'json'

   skip_before_filter :require_login, only: [:create, :index ] 
   respond_to :html, :json
   
    def quotes
      id = params[:id]
      provider= Provider.find id
      if provider.present?
	      @latest_quotes = provider.quotes.desc :created_at
      else
	      @latest_quotes = nil
      end
    end 


    def disabled_days  
      provider = Provider.find(params[:provider_id])
      prices= params[:prices].split(",").map{|p| Moped::BSON::ObjectId.from_string(p)}
      disabled_days = BlockedHour.blocked_days(provider, prices)
      variations = Price.get_variation(provider,prices)
      data = Hash.new
      data[:disabled_days] = disabled_days
      data[:variation_names] = Variation.find_variation(variations)#.join(", ")
      data[:provider_name] = provider.officialname
      data[:duration] = distance_of_time_in_words(Price.calculate_duration(provider,prices))
      data[:sum_prices] = Price.sum_prices(provider,prices)
      data[:service_s] = (prices.count  == 1) ? I18n.t('.quotes.booking.service_single') : I18n.t('.quotes.booking.service_multi')
      respond_to do |format|
        format.json { render :json => data}
      end
    end
  
    def available_hours
      provider = Provider.find(params[:provider_id])
      date = Time.zone.parse(params[:date])
      formatted_date = l(date , format: :long_day) 
      prices= params[:prices].split(",").map{|p| Moped::BSON::ObjectId.from_string(p)}
      times = BlockedHour.get_available_hours(provider,prices, date )
      data = Hash.new
      data[:times] = times
      data[:date] = formatted_date
      respond_to do |format|
        format.json { render :json => data}
      end
    end

    def calendar 
      @provider = Provider.find(params[:id])
      @customer = @provider.customers.build
      @user = User.new
      
    end

    def prices      
      id = params[:id]
      provider= Provider.find id
      if provider.present?  
        @workdones = provider.workdones.where(:"prices.active"=>true)
        ids = provider.customers.where(:person_type=>1).to_a.map(&:user_id)
        @staff_members = User.where(:_id.in=>ids)
      else
        @workdones = nil
      end
    end

    def customer_list 
      provider = Provider.find(params[:id])
      data = Jbuilder.encode do |json|
        user_ids = provider.customers.map {|c| c.user_id if c.person_type == 0}.compact
        users = User.where(:_id.in=> user_ids)
        json.data  users.to_a.each do |user| 
          json.id user._id
          json.text user.name + " - "+ user.telephone
        end
      end 
      respond_to do |format|
        format.json  {render :json => data }
      end
    end

    def personel_list

      provider = Provider.find(params[:id])
      data = Jbuilder.encode do |json|
        user_ids = provider.customers.map {|c| c.user_id  if c.person_type == 1}
        users = User.where(:_id.in=> user_ids)
        json.data  users.each do |user|
          json.id user._id
          json.text user.name 
        end
      end 
      respond_to do |format|
        format.json  {render :json => data }
      end
    end
 
    def verification
      respond_to do |format|
        format.js
        format.html
      end
    end
    
    def check_phone 
      @provider= Provider.find_by(:business_phone=> validate_phone(params[:provider][:business_phone]), :user_id.ne => current_user.id)
      @user= User.find_by(:telephone=> validate_phone(params[:provider][:business_phone]), :_id.ne => current_user.id)
      respond_to do |format|
       format.json { render :json => !@provider && !@user}
      end 
    end
    
    def check_email
      @provider= Provider.find_by(:business_email=>  params[:provider][:business_email], :user_id.ne => current_user.id)
      @user= User.find_by(:email=>  params[:provider][:business_email], :_id.ne => current_user.id)
      
      respond_to do |format|
       format.json { render :json => !@provider && !@user }
      end 
    end


    def check_pin
      @provider= Provider.find_by(:tax_pin=> params[:provider][:tax_pin], :user_id.ne => current_user.id)
      respond_to do |format|
       format.json { render :json => !@provider }
      end 
    end
    
    def check_tax_number
      @provider= Provider.find_by(:tax_number=> params[:provider][:tax_number], :user_id.ne => current_user.id)
      respond_to do |format|
       format.json { render :json => !@provider }
      end 
    end 
    
    def getprovideraddress
      provideraddress = {}
      provider =Provider.find(params[:id])
      provideraddress["profile_picture"] = current_user.profile_picture
      provideraddress["name"] = current_user.name
      if provider.blank?     
        provideraddress = get_cookie_address(cookies)
      else
        provideraddress["location"] = [provider.location[1], provider.location[0]]
        provideraddress["address"] = provider.business_address
      end 
      respond_to do |format|
      format.json  { render :json => provideraddress}
      end
    end  
    
    def getlocation  
      if request.post? 
        session[:location] = params[:location].split(",").map { |f| f.to_f}
        session[:variation_id] = Moped::BSON::ObjectId.from_string(params[:variation_id] )
        session[:distance] = params[:distance].to_i 
        data  =   { :location=> session[:location], :distance => session[:distance] }
        respond_to do |format|
        format.json  { render :json => data}
        end
      else  
        quote_data = {}
        quote_data[:center] = [ session[:location][1].to_f, session[:location][0].to_f]
        quote_data[:variation_id] = session[:variation_id]
        quote_data[:radius] = session[:distance].to_f 
        quote_data[:location] =session[:location] 
        quote_data[:rowindex] = 1
        quote_data[:enableselection] = true 
        matched_providers = Provider.matched_providers(quote_data)
        @json = matched_providers.to_gmaps4rails do |provider, marker|
          marker.picture({
            :picture =>  "/assets/number_"+ quote_data[:rowindex].to_s+".png",
            :width   => 32,
            :height  => 32
          })  
          marker.title(provider.officialname)
          provider.officialname = quote_data[:rowindex].to_s + "- " + provider.officialname 
          quote_data[:rowindex] = quote_data[:rowindex]+1
          marker.json(provider.prepare_provider(quote_data)) 
        end
        clear_quote_session
        respond_to do |format|
        format.json  { render :json =>@json} 
        end
      end 
    end   
   
    
  def new 
    @provider = Provider.new 
    session[:distance] = nil
    session[:mobile_verified] = nil 
    session[:location] = nil
    @current_phones =  current_user.providers.map {|p| p.business_phone}.join(",") if  current_user.providers.present?  
   end

  def index
     @providers = Provider.includes(:user).all
  end

  def show
    @provider= Provider.find(params[:id])
    variation_ids = @provider.workdones.where(:"prices.active"=>true).to_a.map { |val| val.prices.first.variation_id} 
    @categories =  Category.where(:"business_function.variations._id".in=> variation_ids)
    @category_list = @categories.map {|cat| [cat.title, cat._id]} 
    @fsq_references = @provider.foursquare_data[:tips].map{|i|  Dish(i, Reference)} if @provider.foursquare_data.present? 
    @business_description = @provider.business_description.present? ? @provider.business_description : @provider.facebook_data[:description]
    unless @provider.references.count == 0
      @reviewavarage = (@provider.references.map{|r| r.rating}.sum.to_i/@provider.references.count) 
    end   
    session[:current_provider] =  @provider._id 
  end
  
  def getprovider
    provider= Provider.find(params[:id]).includes(:quote)
    workdone =  provider.workdones.where(:"prices.active"=>true, :category_id=> params[:category])
    @jsonprovider =  provider.prepare_provider(workdone, 0, 0, false, 1) 
    respond_to do |format|
      format.json  { render :json => @jsonprovider}
    end 
  end
  
  def getuserproviders
    @jsonprovider = current_user.providers.desc :created_at
     respond_to do |format|
     format.json  { render :json => @jsonprovider}
     end
  end
 
  def create

    categories = JSON.parse(params[:categories]) 
    @provider = current_user.providers.new(provider_params)  
    @provider.business_hours = ActiveSupport::JSON.decode(params[:business_hours])
    @provider.location = [params[:longitude].to_f, params[:latitude].to_f] 
    @provider.decomposed_address =  Address.decompose_address(@provider.location , params) 
    @provider.foursquare_data = {:uri =>params[:foursquare_data]} 
    @provider.facebook_data = {:uri =>params[:facebook_data]} 
    @provider.twitter_data = {:uri =>params[:twitter_data]} 
    @provider.googleplus_data = {:uri =>params[:googleplus_data]} 
    @provider.instagram_data = {:uri =>params[:instagram_data]} 
    @provider.provider_images = transloadit_provider_images(params[:transloadit], @provider.provider_images)
    @provider.set_tax_params(params[:provider][:business_type].to_i)
    @provider.overall_score = 10
    # open it when you activate phone!!! @provider.set_phone_verification(session[:mobile_verified],params[:provider][:business_phone] )  
    @provider.set_phone_verification(true,params[:provider][:business_phone])  
    if @provider.save! 
      @provider.assign_workdones(categories) 
      @provider.create_customer(1)
      @provider.notify_registration 
      @provider.fetch_social_media
      redirect_to provider_path(@provider.slug), flash: { success: t('flash.providers.success.create') } 
    else
      render :new
    end
  end

  def edit
    @provider= Provider.find(params[:id])
    @current_phones = current_user.providers.map {|p| p.business_phone} 
  end

  def update 
    categories = JSON.parse(params[:categories]) 
    @provider = current_user.providers.find params[:id]
    @provider.update_attributes(provider_params) 
    @provider.foursquare_data = {:uri =>params[:foursquare_data]} 
    @provider.facebook_data = {:uri =>params[:facebook_data]} 
    @provider.twitter_data = {:uri =>params[:twitter_data]}
    @provider.googleplus_data = {:uri =>params[:googleplus_data]} 
    @provider.instagram_data = {:uri =>params[:instagram_data]}  
    @provider.set_tax_params(params[:provider][:business_type].to_i)
    @provider.set_phone_verification(session[:mobile_verified],params[:provider][:business_phone] )
    @provider.location = [params[:longitude].to_f, params[:latitude].to_f]  
    @provider.decomposed_address  = Address.decompose_address(@provider.location , params) 
    @provider.business_hours = ActiveSupport::JSON.decode(params[:business_hours])
    images = transloadit_provider_images(params[:transloadit], @provider.provider_images )
    @provider.provider_images  = images if images !=nil 
    if @provider.save!
       @provider.assign_workdones(categories) 
      session[:mobile_verified] = false
      redirect_to provider_path(@provider.slug), flash: { success: t('flash.providers.success.update') }
    else
      render :edit
    end
  end
 

  def destroy
    @provider = current_user.providers.find params[:id]
    if @provider.destroy
      redirect_to providers_user_path(current_user), flash: { success: t('flash.providers.success.destroy') }
    else
      redirect_to providers_user_path(current_user), flash: { error: t('flash.providers.error.destroy') }
    end
  rescue
    redirect_to providers_user_path(current_user), flash: { error: t('flash.providers.error.destroy') }
  end

  def search
    @providers = ProviderSearch.new(params[:providers_search], current_user).providers
  end
 
  private
  def provider_params
    params.required(:provider).permit(    
      :provider_images,  
      :location,  
      :officialname,
      :business_description,
      :business_type, 
      :tax_business_name,
      :tax_office,
      :tax_number,
      :tax_fullname,
      :tax_pin,
      :business_phone,
      :website,
      :office_phone,
      :business_address ,
      :latitude,
      :longitude,
      :gmaps, 
      :categories,
      :verified,
      :business_phone,
      :business_email,
      :overall_score, 
      :overall_quote_given,  
      :overall_quote_done, 
      :decomposed_address, 
      :mobile_verified,
      :business_hours) 
    end 
end
