class AddressesController < ApplicationController
  respond_to :html, :json
 
  def find_children 
    if params[:province].present?
      session[:province]= params[:province]
      session[:district] = nil
      result = Address.get_children(params[:province],session[:province], nil)
    elsif params[:district].present?
      session[:district] = params[:district]
      result = Address.get_children(params[:district],session[:province], 0)
    elsif params[:neigbor].present?
      result = Address.get_children(params[:neigbor],session[:district], nil)
    else
    end
    respond_to do |format| 
      format.json { render json: result}
    end  
  end 
  
end






 