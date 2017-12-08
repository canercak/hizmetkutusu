
class Provider
 
  include Geocoder::Model::Mongoid
  include Mongoid::Document  
  include Mongoid::Timestamps
  include Mongoid::Geospatial
  include ::Concerns::Provider::Foursquare
  include ::Concerns::Provider::Facebook
  include ::Concerns::Provider::Twitter
  include ::Concerns::Provider::Googleplus
  include ::Concerns::Provider::Instagram
  include Mongoid::Slug
  include PublicActivity::Model
  include Mongoid::Orderable
  include ActionView::Helpers::DateHelper

  tracked :owner => :user
    tracked :params => {
    :id =>:_id,
    :verified => :verified,
    :quote_ids => :quote_ids
  } 

  slug :decomposed_address, :officialname do |cur_object|
    slug  = cur_object.generate_slug
    slug.to_url
  end

 

  acts_as_gmappable :position => :location, :process_geocoding => true,
  :check_process => :prevent_geocoding,
  :address => :business_address 

  attr_accessor  :verification_phone,:verification_code,:hiddencode, 
                 :latitude, :longitude,:categories, 
                 :province, :district, :neigbor, :local, :no_door, :street
                  
  
  has_many :quotes 
  belongs_to :user
  embeds_many :references 
  embeds_many :workdones
  embeds_many :blocked_hours
  embeds_many :customers
  embeds_many :reservations
  index "workdones.prices" => 1
  index "workdones.category_id" => 1
 
  has_many :conversations, as: :conversable, dependent: :destroy 
  index "workdones.category_id" => 1 

  delegate :name, to: :user, prefix: true
  delegate :first_name, to: :user, prefix: true

  field :provider_images, :type => Hash
  field :location, :type => Array  
  index({ location: "2d" }, { min: -200, max: 200 }) 
  field :officialname
  field :business_description
  field :business_type, type: Integer, default: 1
  field :tax_business_name
  field :tax_office
  field :tax_number, type: Integer 
  field :tax_fullname
  field :tax_pin, type: Integer 
  field :business_address
  field :decomposed_address, type: Hash
  field :foursquare_data, type: Hash
  field :facebook_data, type: Hash
  field :twitter_data, type: Hash
  field :googleplus_data, type: Hash
  field :instagram_data, type: Hash
  field :business_phone 
  field :business_email 
  field :latitude
  field :longitude
  field :overall_score, type: Integer, default: 0
  field :overall_quote_given, type: Integer, default: 0
  field :overall_quote_done, type: Integer, default: 0
  field :website
  field :office_phone
  field :gmaps, :type=> Boolean
  field :verified, type: Boolean, default: false
  field :mobile_verified, type: Boolean, default: false 
  field :business_hours, type: Array

 

  validates :officialname, length: { minimum: 5, maximum: 50 }, presence: true, uniqueness: true
  #validates :business_description, length: { minimum: 20, maximum: 500 }, presence: true
  #validates :business_type, presence: true  
  #validates :business_phone,  presence: true
  #validates :office_phone,  presence: true
  #validates :business_email, presence: true
  #validates_format_of :business_email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
  #validates :tax_number, length: { is: 10 },  presence: true, uniqueness: true,  :if => :company? 
  #validates :tax_office, presence: true, :if => :company? 
  #validates :tax_business_name, presence: true, :if => :company? 
  #validates :tax_pin, length: { is: 11 }, presence: true, uniqueness: true, :if => :personal? 
  #validates :tax_fullname, presence: true, :if => :personal?  
 
  def personal?
    if business_type == 1 || business_type == 0
        return true
    else 
        return false
    end
  end
  
  def company? 
    if business_type == 2 || business_type == 3
        return true
    else 
        return false
    end
  end  
  
  def prevent_geocoding
     business_address.blank? || (!latitude.blank? && !longitude.blank?)
  end
  
  def gmaps4rails_address
    "#{self.business_address} "
  end
 
  def title
    [business_address].join ' - '
  end

  def fetch_social_media
    begin
      Resque.enqueue(FoursquareDataCacher, self._id) 
      Resque.enqueue(FacebookProviderDataCacher, self._id)
      Resque.enqueue(TwitterDataCacher, self._id)
      Resque.enqueue(GoogleplusDataCacher, self._id)
      Resque.enqueue(InstagramDataCacher, self._id) 
    rescue  Exception => e 
       logger.warn "Error #{e}" 
    end
  end

  def to_s
     title || id
  end
  
  def to_param
   id 
  end


  
  def assign_new_workdone(variations)
    categories = Category.find_categories(variations)
    categories.each do |category|
      workdone = self.workdones.find_by(:category_id=>category._id)
      if workdone.blank?
        workdone = self.workdones.create!(:category_id=>category._id) 
      end
      category.business_function.variations.each do |variation|
        if variations.include?(variation._id)
          pricelow = Price.get_high_lows(variation._id ,self) 
          workdone.prices.create(:variation_id => variation._id, 
           :price=> (pricelow.present? ? pricelow[0] : variation.base_price.to_f),
           :discount=> 0, # todo
           :duration=> variation.duration, #Duration.new(:minutes => variation.duration),
           :active => true,
           :staff_ids=> [self.user._id])
        end
      end
    end
  end

  def assign_workdones(categories)
    selected_variations = ApplicationController.helpers.selected_variations(categories) 
    active_variations = []
    inactive_variations = []
    if self.workdones.blank?
       self.assign_new_workdone(selected_variations)
    else
      active_variations = self.workdones.map{|w| w.prices.map{|p| p.variation_id if p.active == true}}.reduce(:+)
      inactive_variations = self.workdones.map{|w| w.prices.map{|p| p.variation_id if p.active == false}}.reduce(:+)
      variations_to_deactivate = (active_variations + inactive_variations) - selected_variations  
      self.workdones.map{|w| w.prices.map{|p| p.update_attribute(:active, false) if variations_to_deactivate.include?(p.variation_id)}}
      selected_variations.each do |var| 
        if !active_variations.include?(var) &&  !inactive_variations.include?(var) 
          self.assign_new_workdone([var])
        elsif !active_variations.include?(var) && inactive_variations.include?(var) 
          price = self.workdones.where(:"prices.variation_id"=> var)
          price.to_a[0].update_attribute(:active, true)
        else
        end
      end
    end 
  end 

  def generate_slug
    begin
      province = self.decomposed_address[:province]
      district = self.decomposed_address[:district]
      neigbor = self.decomposed_address[:neigbor]
      local = self.decomposed_address[:local]
      offname = self.officialname
      slug =  offname + " " + province + " " + district + " "+ neigbor + " "  + local 
    rescue Exception => e
    end
  end

 

  def notify_registration
    user = self.user
    identity = Identity.find_by(:email=>user.email)
    sms = Sms.new 
    if identity.present? && identity.admin_password.present? 
      sms.send_multi_sms([self.business_phone], [I18n.t('sms.new.notify_welcome_provider', email: self.business_email, admin_password: identity.admin_password) ],  "welcome_provider_admin_pass", nil) 
    else 
       sms.send_multi_sms([self.business_phone], [I18n.t('sms.new.notify_welcome_provider_normal') ],  "welcome_provider", nil) 
    end 
    ProviderMailer.registration_email(self,user.email,user.admin_password).deliver 
  end

  def set_phone_verification(mobile_verified, phone)
    self.mobile_verified = mobile_verified
    self.business_phone = ApplicationController.helpers.validate_phone(phone)
    if self.mobile_verified == true
      user = User.find(self.user_id)
      return user.verify_phone(self.business_phone) 
    end  
  end

  def set_tax_params(business_type)
    if business_type < 2 
      self.tax_office = nil
      self.tax_number = nil 
      self.tax_business_name = nil
    else
      self.tax_fullname = nil 
      self.tax_pin = nil
    end
  end
  
   def create_customer(person_type)
    self.customers.create(:user_id=>self.user._id, person_type: person_type)
  end
 

  def self.matched_providers(quote_data) 
    provider_array = Provider.where(:location =>  {"$near" => quote_data[:center],'$maxDistance' => quote_data[:radius].fdiv(111.12)},
                                    :"workdones.prices.variation_id" =>quote_data[:variation_id],
                                    :"workdones.prices.active" => true,
                                    # :"workdones.prices.price".gt=> 0,
                                    # #:"workdones.give_price"=> true,
                                    ).order_by(:"workdones.prices.price".desc)
    return provider_array
  end
 

  def prepare_provider(quote_data) 
    price =  self.workdones.map{|w| w.prices.map {|p| p if p.variation_id == quote_data[:variation_id]}}.reduce(:+).compact.reduce(:+)
    category = Category.find(price.workdone.category_id)
    references =  self.references 
    fsq_photos = self.foursquare_data[:photos]
    fsq_references = self.foursquare_data[:tips].map{|i|  Dish(i, Reference)}
    references.each_with_index do |reference,index|
      references[index].day_ago = I18n.t('conversations.messages.time_ago', time: distance_of_time_in_words(reference.created_at, Time.now.utc)) 
    end
    staravg = 0
    unless references.count == 0
      staravg= (references.map{|r| r.rating}.sum.to_i/references.count) 
    end  
    provider_image = nil
    if self.provider_images.present?
      provider_image = self.provider_images.provider_image1[0]
    else
      if fsq_photos.present? 
         provider_image = fsq_photos.last 
      else
         provider_image = facebook_data[:picture] || "/assets/profile_pic_small.png"
      end
    end

    provider_data = {:id => self._id, 
      :officialname =>  self.officialname, 
      :business_description => self.business_description.present? ? self.business_description : self.facebook_data[:description],
      :provider_images => self.provider_images, 
      :verified => self.verified,
      :quotelat=>self.location[1],
      :quotelon=>self.location[0],
      :provider_path=>Rails.application.routes.url_helpers.provider_path(self.slug),
      :refcount=>references.count, 
      :overall_score=> self.overall_score, 
      :staravg=> staravg,  
      :references => references,
      :foursquare_photos => fsq_photos,
      :price => price.price.present? ? ApplicationController.helpers.remove_trailing(price.price) : nil,
      :unit=>category.business_function.unit, 
      :price_id=>price._id, 
      :category_id=>category._id,
      :quotegivencount =>self.overall_quote_given,
      :fsq_references=>fsq_references,
      :workdonecount => self.overall_quote_done,
      :profile_image=>provider_image,
      :fs_likes => self.foursquare_data[:likes],  
      :fc_likes => self.facebook_data[:likes], 
      :fs_checkins => self.foursquare_data[:checkinscount],  
      :fc_checkins => self.facebook_data[:checkins], 
      :like_total => ApplicationController.helpers.calculate_counts(self.foursquare_data[:likes],self.facebook_data[:likes]),
      :checkin_total => ApplicationController.helpers.calculate_counts(self.foursquare_data[:checkinscount],self.facebook_data[:checkins]),
      :rowindex => quote_data[:rowindex]-1, 
      :enableselection =>quote_data[:enableselection] }
    return provider_data
  end  

  def update_blocked_hours(categories, staff_ids, start_date, end_date, reason, block_id)
 
    blocked_hours = self.blocked_hours.find(block_id)
    blocked_hours = self.blocked_hours.build if blocked_hours.blank?
    blocked_hours.category_id = categories
    blocked_hours.staff_ids = staff_ids
    blocked_hours.start_date = start_date
    blocked_hours.end_date = end_date
    blocked_hours.block_reason = reason 
    blocked_hours.save!
  end

end
