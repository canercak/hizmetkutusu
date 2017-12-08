require "active_model_otp"
class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include ::Concerns::User::Authentication
  include ::Concerns::User::Facebook
  include ActiveModel::OneTimePassword
  include PublicActivity::Model
  include ApplicationHelper

  #attr_accessor   :verification_phone,:verification_code, :hiddencode,:verification_phone


  GENDER = %w(male female)
  paginates_per 25
  index({ username_or_uid: 1 }) 
  
  has_many :quotes, dependent: :destroy
  has_many :providers, dependent: :destroy
  has_many :feedbacks
  has_many :transactions
  has_one :identity
  has_one_time_password 
  has_and_belongs_to_many :conversations
  embeds_many :notifications 

   #before_create { generate_token(:auth_token) }
  field :new_password
  field :old_password
  field :password
  field :password_confirmation
  field :ammount
  field :password_reset_token
  field :password_reset_sent_at, type: DateTime 
  field :auth_token
  field :useridentity_image, :type => Array
  field :staff_provider, :type => Array
  field :customer_provider, :type => Array 
  field :provider
  field :uid
  field :oauth_token
  field :oauth_expires_at 
  field :facebook_permissions, type: Hash, default: {}
  field :facebook_friends, type: Array, default: []
  field :facebook_favorites, type: Array, default: []
  field :facebook_data_cached_at, type: DateTime, default: '2014-01-01'
  field :email
  field :name
  field :otp_secret_key
  field :facebook_verified, type: Boolean, default: false
  field :phone_verified, type: Boolean, default: false
  field :telephone
  field :username, default: "hizmetkutusu_user"
  field :gender
  field :bio
  field :languages, type: Array, default: []
  field :birthday, type: Date
  field :work, type: Array, default: []
  field :education, type: Array, default: []
  field :locale
  field :time_zone, default: 'Istanbul' # think about it  
  field :admin, type: Boolean, default: false
  field :banned, type: Boolean, default: false
  field :ammount 
  field :username_or_uid
  field :send_email_newsletter, type: Boolean, default: true
  field :send_email_statistics, type: Boolean, default: true
  field :send_email_references, type: Boolean, default: true
  field :login_count, :type=>Integer, default: 0
  field :score, :type=>Integer, default: 0
  field :user_image
  field :admin_password
 
 
  #validates :time_zone, inclusion: ActiveSupport::TimeZone.zones_map(&:name).keys, allow_blank: true
  ##validates :gender, inclusion: GENDER, allow_blank: true
  #email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  
  def verify_phone(phone)
    self.update_attributes!(telephone: phone, phone_verified: true)
  end 

  def age
    ((Time.now.to_s(:number).to_i - birthday.to_time.to_s(:number).to_i) / 10e9.to_i) if birthday?
  end

  def first_name
    @first_name ||= name.split[0] if name?
  end

  def to_s
    name || id
  end

  def to_param
    username || uid || id
  end

  def profile_picture(type = 'square')
    "https://graph.facebook.com/#{uid}/picture?type=#{type}"
  end

  def unread_conversations_count
     conversations.unread(self).size
  end


  def unread_references_count
    references.unread.size
  end

  def male?
    gender == 'male'
  end


  def self.define_identity(email)
    current_identity = nil
    user_current = User.find_by(:email=>email)
    if (user_current.present? && user_current.provider == "identity")
      current_identity  = user_current
    end
    return current_identity
  end
  

  def self.create_dummy(params)
    user = User.new
    user.name = params[:name]
    user.email = params[:email]
    user.provider = "identity"
    user.telephone = ApplicationController.helpers.validate_phone(params[:phone])
    user.save!
    return user
  end

  def female?
    gender == 'female'
  end

    
  def send_password_reset(user) 
    user.password_reset_token = SecureRandom.urlsafe_base64
    user.password_reset_sent_at = Time.zone.now    
    user.save!
    UserMailer.password_reset_email(user).deliver
  end

  def update_staff_provider(provider, type)
    id = provider._id 
    if type == 1
      Price.update_staff(provider, self._id)
      (self.staff_provider = []) if self.staff_provider.blank? 
      self.staff_provider <<  id 
    else
      (self.customer_provider = []) if self.staff_provider.blank? 
      self.customer_provider <<  id 
    end 
    self.save!
  end
  
 
  def check_phone(phone) 
     provider= Provider.find_by(:business_phone=> validate_phone(phone), :user_id.ne => self._id)
    user= User.find_by(:telephone=> validate_phone(phone), :_id.ne => self._id) 
    data = nil
    if provider.present?
      data = provider.user
    else
      if user.present?
        data = user
      end
    end 
    return data
  end
end

