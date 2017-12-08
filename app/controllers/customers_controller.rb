class CustomersController < ApplicationController
 

  def index
  	@provider = Provider.find(params[:provider_id])
  	customers = @provider.customers.map{|c| c.user_id}
    @users = User.where(:id.in=>customers) 
  end
 
  def show
    @customer = Customer.find(params[:id])
  end

  def new
  	@provider = Provider.find(params[:provider_id])
    @customer = @provider.customers.build
    @user = User.new
  end

  def create 
  	provider = Provider.find(params[:provider_id])
  	user = current_user.check_phone(customer_params[:phone])
  	if user.present?  
  		customer = provider.customers.find_by(:user_id=> user._id)
      customer = provider.customers.build if customer.blank?
      if customer.update_customer(user,provider,customer_params)
  		  redirect_to provider_customers_path(provider._id), flash: { success: t('flash.customers.success.create_new_user') }
  		else
  			flash.now[:info] = t('flash.customers.error.cannot_save_customer_without_user')  
      	render :new
    	end
  	elsif user.blank?  
  		user = User.create_dummy(customer_params)
	  	if Customer.save_new(provider, user, customer_params)
        redirect_to provider_customers_path(provider._id), flash: { success: t('flash.customers.success.create_customer_user') }
    	else
  			flash.now[:info] =  t('flash.customers.error.cannot_save_customer_with_user')  
      	render :new
    	end    		
    else
      flash.now[:info] =  t('flash.customers.error.customer_exists')  
      render :new
    end 
   end
 

  def edit 
  	user_id = Moped::BSON::ObjectId.from_string(params[:id])
  	@provider = Provider.find(params[:provider_id])
    @customer = @provider.customers.where(:user_id=>user_id).to_a[0]
    @user = User.find(user_id)
  end

  def update
  	provider = Provider.find(params[:provider_id])
  	user = current_user.check_phone(customer_params[:phone])
    customer = provider.customers.find_by(:user_id=> user._id)
		if customer.update_customer(user,provider, customer_params)
			redirect_to provider_customers_path(provider._id), flash: { success: t('flash.user.success.create_new_user') }
    else
			flash.now[:info] = t('flash.customers.errors.cannot_save_customer_without_user')  
    	render :new
  	end 
  end

  def destroy
  	user_id = Moped::BSON::ObjectId.from_string(params[:id])
  	provider = Provider.find(params[:provider_id])
    @customer = provider.customers.where(:user_id=>user_id).to_a[0]
    if @customer.destroy
      redirect_to provider_customers_path(provider._id), flash: { success: t('flash.customers.success.destroy') }
    else
      redirect_to provider_customers_path(provider._id), flash: { error: t('flash.customers.error.destroy') }
    end
  end

   def customer_params
    params.required(:customer).permit(:user_id, :name, :email, :phone,  :person_type)
  end 
 
end
 
