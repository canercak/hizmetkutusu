class ActivitiesController < ApplicationController
  def index
    @activities = PublicActivity::Activity.all
  end
  
  
  def get_provider_counts
    @provider = Provider.find(params[:id])
    @activities = PublicActivity::Activity.all 
    selected_providers = [] #@activities.where("parameters.providers"=>@provider._id,"key"=>"quote.create").group_by {|d| d.created_at.to_i}
    returned_providers =[]#@activities.where("parameters.returned_providers"=>"#{@provider._id}","key"=>"quote.update").group_by {|d| d.created_at.to_i}
    done_providers =[] #@activities.where("parameters.providerdone"=>"#{@provider._id}","key"=>"quote.update").group_by {|d| d.created_at.to_i}
    @caldata = {}
    seldata = {}
    retdata ={}
    donedata = {}
    selected_providers.each do |provider|
      seldata = {"#{provider[0]}" => provider[1].count}
    end
    returned_providers.each do |provider|
      retdata = {"#{provider[0]}" => provider[1].count}
    end
    done_providers.each do |provider|
      donedata = {"#{provider[0]}" => provider[1].count}
    end    
    @caldata = donedata.merge(retdata) {|key, oldval, newval| newval + oldval}
    @caldata = @caldata.merge(seldata) {|key, oldval, newval| newval + oldval}
    respond_to do |format|
      format.json  { render :json => @caldata.to_json}
    end
  end
  
  def get_activity
    @provider = Provider.find(params[:id])
    date = Time.zone.parse(params[:selected])
    @activities = PublicActivity::Activity.all 
    selected_providers =[] # @activities.where("parameters.providers"=>@provider._id,:created_at=>date.beginning_of_day..date.end_of_day, "key"=>"quote.create")
    returned_providers =[] #@activities.where("parameters.returned_providers"=>"#{@provider._id}",:created_at=>date.beginning_of_day..date.end_of_day,"key"=>"quote.update") 
    done_providers =[] #@activities.where("parameters.providerdone"=>"#{@provider._id}",:created_at=>date.beginning_of_day..date.end_of_day,"key"=>"quote.update") 
    respond_to do |format|
      format.json  { render :json => {:selected=> selected_providers.count,:returned =>returned_providers.count,:done=>done_providers.count}}
    end
  end
  

  
end
