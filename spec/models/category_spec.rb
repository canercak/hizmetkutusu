# -*- encoding: utf-8 -*-

require 'spec_helper'

	describe Category do 
		let(:variation) { Fabricate(:variation) }
	  let(:provider)  { Fabricate(:price, variation_id: variation._id).workdone.provider }
	  let(:categories) { provider.get_categories(true)} 

		 describe "#list_provider_categories" do 
	    it "should return list of all categories" do
	      result = provider.list_provider_categories(provider,categories)
	      expect(result).not_to be(nil)
	    end 

	    it "should mark provider's categories" do
	      result = provider.list_provider_categories(provider,categories)
	      expect(JSON.parse(result)[:selected]).not_to be(nil)
	    end  

	  end 
	end
