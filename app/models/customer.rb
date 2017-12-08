class Customer
  include Mongoid::Document

  attr_accessor :phone, :name, :email
	
	embedded_in :provider
	field :user_id 
	field :person_type, :type=> Integer

 
	def self.save_new(provider,user, customer_params) 
		customer = provider.customers.build 
  	customer.person_type = customer_params[:person_type].to_i
  	customer.user_id = user._id
  	if customer.save! && user.update_staff_provider(provider, customer.person_type) 
      UserMailer.invitation_email(user, user.otp_code, provider ).deliver 
      return true
    end
	end


  def update_customer(user,provider,params)
    if self.update_attributes(params)
      #user.update_staff_provider(provider) if self.person_type == 1
      if params[:email] != user.email
        UserMailer.invitation_email(user, user.otp_code, provider ).deliver 
      else
        UserMailer.customer_email(user,provider).deliver 
      end
      return true
    end
  end


  def self.staff_from_variations(provider, variation_ids)
      staff = []
      staff_variations = provider.workdones.map{|w| w.prices.map{|p| [p.variation_id, p.staff_ids]}}.reduce(:+)
      staff_variations.each do |sv|
        if variation_ids.include? sv[0]
          staff << sv[1]
        end
      end
      return User.where(:_id.in=>(staff.reduce(:+))).to_a 
  end
 

end