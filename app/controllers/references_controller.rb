# encoding: UTF-8
class ReferencesController < ApplicationController
  include ApplicationHelper
  include UsersHelper
  include ReferencesHelper
  before_filter :require_login 

  def index
    @provider = find_providerbyid params[:provider_id]
    @references = @provider.references.desc(:updated_at).page params[:page]
  end

  def edit 
    @quote = Quote.find(params[:id])
    @provider= Provider.find params[:provider_id]
    @reference = @provider.references.detect { |pr| pr.id.to_s == params[:id] }
  end

  def new
    @quote = Quote.find(params[:id])
    @provider=  @quote.provider
    @reference = @provider.references.build
  end

  def create 
    @provider= Provider.find(params[:provider_id])
    @reference = @provider.references.new#build(reference_params)
    @reference.quote_id = params[:quote_id]
    @reference.user_image = facebook_profile_picture(current_user)
    @reference.firstname = get_first_name(current_user.name)
    @reference.user_id = current_user.id   
    @reference.rating =  params[:ratehidden].to_i
    @reference.comment = params[:comment]
    @quote = Quote.find @reference.quote_id
    @reference.category_name=Variation.find_variation(@quote.variation_id).join(",") 
    if @reference.save  
      @quote.update_attribute(:reference_id, @reference._id)
      scorechanges = Hash.new
      scorechanges[:rating] = [true, @reference.rating.to_i]    
      Workdone.update_scores("customer_rating", @quote, @quote.provider, scorechanges)
      redirect_to quote_path(@quote), flash: { success:  t('flash.references.success.create') }  
    else
      render :new
    end
  end

  def show
    @provider= find_providerbyid params[:provider_id]
    @reference = @provider.references.find(params[:id]) 
  end

  def update
    @provider= Provider.find(params[:provider_id])  
    @reference = @provider.references.find(params[:id])
    @quote = Quote.find @reference.quote_id 
    new_rating = params[:ratehidden].to_i  
    current_rating = @reference.rating    
    @reference.rating = new_rating
    @reference.comment = params[:comment]
    @reference.user_image = facebook_profile_picture(current_user)
    @reference.firstname = get_first_name(current_user.name)
    @reference.user_id = current_user.id

    if @reference.save 
      if new_rating != current_rating
       Workdone.update_scores("customer_rating_down", @quote, @provider,current_rating)
       Workdone.update_scores("customer_rating_up", @quote, @provider, new_rating) 
      end 
      redirect_to quote_path(@quote), flash: { success:  t('flash.references.success.update') } 
    else
      render :new
    end
  end 
  
  private
  def reference_params
    params.required(:reference).permit(    
    :rating,
    :category_name,
    :quote_id,
    :user_image,
    :firstname,
    :user_id,
    :comment,
    :day_ago 
    )
  end  
end
