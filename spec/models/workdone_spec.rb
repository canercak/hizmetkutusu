# -*- encoding: utf-8 -*-

require 'spec_helper'

describe Workdone do

	let(:variation) { Fabricate(:variation) }
  let(:provider)  { Fabricate(:price, variation_id: variation._id).workdone.provider }
  let(:staffuser) { Fabricate(:user)}
  let(:staff) { Faricate(:customer, user_id: staffuser._id, person_type: 1)}


  
  describe "#update_prices" do
  	let(:params) { {provider.workdones.first._id.to_s=>{:give_price=>true, :price0=>19, :duration0=>300}} }
  	it "should successfully update prices" do
  		expect(Workdone.update_prices(provider,params)).to be true
  	end 

  	it "should successfully update staff" do
  		params[provider.workdones.first._id.to_s][:staff_ids] = [staffuser._id]
			expect(Workdone.update_prices(provider,params)).to be true
  	end
  end 

end
