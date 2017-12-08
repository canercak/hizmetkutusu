# encoding: UTF-8 
class WorkdonesController < ApplicationController
 
  def index
 
  end

  def new
 
  end

  def create    
 
  end

  def show
 
   end

  def update
 
  end

 


  def get_variation

    category = Category.find(params[:id])
    result = []
    variations = category.business_function.variations
    if variations.count > 1
      variations.each do |var|
        result << {id: var._id, text: var.variation} 
      end
    end 
    respond_to do |format|
      format.json  {render :json => result}
    end
  end
  
  def update_all 
    provider = Provider.find(params[:id]) 
    if Workdone.update_prices(provider, params['workdone'])
      redirect_to prices_provider_path(provider.slug), flash: { success: t('flash.providers.success.price') } 
    else
      redirect_to prices_provider_path(provider.slug), flash: { error: t('flash.providers.error.price') } 
    end
  end
 
end
