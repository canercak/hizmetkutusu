 
 require 'securerandom'
 namespace :foursquare do
	 extend ActiveSupport::Concern
  desc "update provider foursquare data"
  task :update => :environment do  
		require 'spreadsheet'
		path = Rails.root.join('lib/providers/list.xls')
		foursquare = Foursquare2::Client.new(:client_id => APP_CONFIG.foursquare.client_id,
                                           :client_secret => APP_CONFIG.foursquare.client_secret)
		facebook = Koala::Facebook::API.new
 		spreadsheet = Spreadsheet.open path
		sheet1 = spreadsheet.worksheet 0 
		sheet1.each 1 do |sheet1_row|
		  row = sheet1_row
		  if (row[7].present?)
		  	fs_id = row[7].split("/").last
		  	fs_result = foursquare.venue(fs_id, :v=>Date.today.strftime("%Y%m%d")) 
		  	existing_provider = Provider.where("foursquare_data.uri"=> row[7])
		  	if fs_result.present?
			  	if existing_provider.blank?
			  		address = Address.generate_address([fs_result[:location][:lat],fs_result[:location][:lng]])
			  		puts ("creating provider " + row[1])
			  		provider = Provider.new(:decomposed_address => address,
			  			                      :location=> [fs_result[:location][:lat], fs_result[:location][:lng]],
			  			                      :business_hours=> [{"isActive"=>true, "timeFrom"=>"09:00", "timeTill"=>"20:00"}, {"isActive"=>true, "timeFrom"=>"09:00", "timeTill"=>"20:00"}, {"isActive"=>true, "timeFrom"=>"09:00", "timeTill"=>"20:00"}, {"isActive"=>true, "timeFrom"=>"09:00", "timeTill"=>"20:00"}, {"isActive"=>true, "timeFrom"=>"09:00", "timeTill"=>"20:00"}, {"isActive"=>true, "timeFrom"=>"09:00", "timeTill"=>"12:00"}, {"isActive"=>false, "timeFrom"=>"09:00", "timeTill"=>"18:00"}],
			  														:officialname=> row[1],
			  													  :office_phone=>row[3], 
			  													  :gmaps => true, 
			  													  :latitude => fs_result[:location][:lat],
  																	:longitude =>fs_result[:location][:lng],
			  													  :foursquare_data=> {:uri=> row[7]},
			  													  :facebook_data=> {:uri=> row[8]},
			  													  :user_id=> (User.create_dummy({:name=> row[1], :email=>(SecureRandom.hex(3)+"@hizmetkutusu.com" ), :phone=> "02324644733"})._id),	
			  													  :business_address=>address[:formatted_address]) 
 						provider.set_workdones(row[0])
			  		provider.update_foursquare_data(fs_result) 
 					else
 						provider.update_foursquare_data(fs_result) 
 					end

					if (row[8].present? )	
		  			fc_id = row[8].split("/") 
		  			begin
		  				result = nil
		  				result = facebook.get_object("#{fc_id.last.parameterize}")
		  			rescue Exception => e
		  				Rails.logger.info(e)
		  			end
		  			if result.present?
         		   provider.update_facebook_data(result,fc_id)
	     		  else
	       			Rails.logger.info("!!!!!!!!cannot update " + row[7] +" with " + row[0] + " " +row[1] + "!!!!!!!")	
	      		end
	   		  end 

	      else
	       	Rails.logger.info("!!!!!!!!cannot update " + row[7] +" with " + row[0] + " " +row[1] + "!!!!!!!")	
	      end
	    end
 
		end
	end
end