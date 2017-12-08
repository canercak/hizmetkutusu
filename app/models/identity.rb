class Identity
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic
  include OmniAuth::Identity::Models::Mongoid
 
  field :email, type: String
  field :name, type: String
  field :password_digest, type: String
  field :username, type: String
  field :admin_password
 
  attr_accessor :otp 

 
 
  belongs_to :user
  #validate :uniqueness_of_email
  #validates_format_of :email, :with => /^[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}$/i
  
 
  
end
