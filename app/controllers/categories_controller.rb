# encoding: UTF-8
class CategoriesController < ApplicationController
  respond_to :html, :json
  skip_before_filter :require_login 
  def list_styles  
    if params[:q].present?
      @categories = Category.search(params[:q] ,fields: [:title, :parent, :ancestors, :variations], order: {parent: :desc}) #, execute: false, execute: false ) 
      data = Category.list_search_categories(@categories.results)
      respond_to do |format|
        format.json  {render :json => data}
      end 
    end
  end
 
  def get_variation 
    category = Category.find(params[:id])
  	result = []
    variations = category.business_function.variations
    if variations.count > 0
     	variations.each do |var|
        result << {id: var._id, text: var.variation} 
      end
    end 
    respond_to do |format|
    	format.json  {render :json => result}
    end
  end


  def get_allcategories 
    provider = Provider.find(params[:provider_id])
    categories =  Category.all.to_a.map {|c| c}
    data = Category.list_provider_categories(provider,categories)
    respond_to do |format|
      format.json  {render :json => data}
    end 
  end 

end
