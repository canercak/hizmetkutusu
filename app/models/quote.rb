require 'autoinc'
class Quote
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Slug
  include Geocoder::Model::Mongoid
  include Concerns::GmapRoute
  include Mongoid::Autoinc
  include PublicActivity::Model 
 
  attr_accessor :selected_providers, :verification_phone, :verification_code, 
                :hiddencode, :distance, :latitude, :longitude,:verification_phone,
                :reservation_date, :query_date, :variation_text 
  belongs_to :provider
  belongs_to :user
  has_many :conversations, as: :conversable, dependent: :destroy 
  delegate :name, to: :user, prefix: true
  delegate :first_name, to: :user, prefix: true

  field :customer_address
  field :location, :type => Point 
  field :share_on_facebook_timeline, :type=> Boolean
  field :gmaps, :type=> Boolean
  field :uid, :type=> Integer 
  field :variation_id, :type=>Array
  field :reference_id

  slug  :id, :customer_address, reserve: %w(new) 
  spatial_index :location
  increments :uid, seed: 3322
  tracked :owner => :user
  tracked :params => {:providers => :provider_ids} 
 
  #validates :variation_id, presence: true 
  #validates :customer_address, presence: true
 

  def prevent_geocoding
    customer_address.blank? || (!latitude.blank? && !longitude.blank?)
  end
  
  def gmaps4rails_address
    "#{self.customer_address} "
  end 
  
  def notify_provider_and_user
    sms = Sms.new    
    quote_user = User.find(self.user_id)
    category = Category.find_categories(self.variation_id).to_a[0]
    service = category.parent + "-" + category.title + ": " +  category.business_function.variations.map {|v| v.variation if v._id = self.variation_id.first}.join
    shortlink = Googl.shorten("#{APP_CONFIG.base_url}/fiyat/#{self.slug}").short_url
    date_rez = self.provider.reservations.find_by(:quote_id=>self._id).start_date
    phone_array = [self.provider.business_phone, quote_user.telephone]
    email_array = [provider.business_email, quote_user.email]
    provider_massage = self.prepare_provider_message(provider,category,service,shortlink,date_rez)
    user_message = self.prepare_user_message(quote_user,category,service,shortlink,date_rez) 
    sms.send_multi_sms(phone_array,[provider_massage,user_message[0]], "newquote", self.id) 
    ProviderMailer.new_quote_email(email_array[0],provider_massage, self).deliver
    UserMailer.new_quote_email(email_array[1],user_message[1], self).deliver 
    # begin        
    #   Resque.enqueue(SmsReceiver) 
    # rescue Redis::CannotConnectError
    # end
  end 
  
  def prepare_provider_message(provider,category,service,shortlink,date_rez)
    #sms_phone = provider.business_phone.slice(0) 
    distance =  Geocoder::Calculations.distance_between([self.location.y, self.location.x], provider.location, {:units=>:km}).round(2)
    full_message = I18n.t("sms.new.notify_provider_sms_price",distance: distance,  customer:  self.user.name, date_service: date_rez.strftime("%d %m %Y, %H:%M"),  service: service,   customer_phone: self.user.telephone , shortlink: shortlink ) 
    return full_message
  end

  def prepare_user_message(user,category,service,shortlink,date_rez)
    sms_message = I18n.t("sms.new.notify_user_sms_price",provider: self.provider.officialname,  date_service: date_rez.strftime("%d %m %Y, %H:%M"),  service: service, shortlink: shortlink ) 
    email_message = I18n.t("sms.new.notify_user_email_price",provider: self.provider.officialname,  date_service: date_rez.strftime("%d %m %Y, %H:%M"),  service: service ) 
    return [sms_message, email_message]
  end

 
  def process_after_quote(prices_array, reservation_date)
    eligible_staff =self.provider.workdones.map{|w| w.prices.map{|p| p.staff_ids if prices_array.include?(p._id) }}.reduce(:+).compact.reduce(:+)
    staff_ids = [eligible_staff.sample] 
    self.create_customer(self.provider)
    reservation = self.provider.reservations.build
    reservation.customer_originated = true
    reservation.description = "Kendisi Randevu Aldı"
    reservation.variation_names = self.user.name
    reservation.make(self,prices_array,reservation_date,staff_ids, 0) 
  end

  def create_customer(provider)
    if provider.customers.present?
       provider_customers = provider.customers.map{|c|c.user_id if c.person_type == 0}
      if !provider_customers.include?(self.user._id)
        provider.customers.create(user_id: self.user._id, person_type: 0)
      end
    else
      provider.customers.create(user_id: self.user._id, person_type: 0)
    end
  end

 
end
