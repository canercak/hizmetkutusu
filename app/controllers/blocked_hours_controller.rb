class BlockedHoursController < ApplicationController 
  include ReservationsHelper
 
  def save 
    dates = calendar_dates(params[:date], params[:start], params[:end])
    provider = Provider.find(params[:provider_id]) 
    categories = params[:categories_block].split(",").map {|v| Moped::BSON::ObjectId.from_string(v)}
    staff_ids = Array.new
    if params[:staff_block] == "0000"
      staff_ids = Price.allstaff_from_categories(provider,categories)
    else
      staff_ids = params[:staff_block].split(",").map {|v| Moped::BSON::ObjectId.from_string(v)}
    end
    reason = params[:block_reason]
    if provider.update_blocked_hours(categories,staff_ids, dates[0], dates[1], reason, params[:block_id]) 
      respond_to do |format| 
        format.json {render :json => provider.reservations.to_json } 
      end 
    else
      redirect_to calendar_provider_path(@provider._id), flash: { error: t('flash.events.error.save') }
    end 
  end 

end
