
require 'spec_helper'

describe Provider do
  
  include CategoryParams 
  let(:variation) { Fabricate(:variation) }
  let(:provider)  { Fabricate(:price, variation_id: variation._id).workdone.provider }
  let(:category_params) {full_params}
 
  it "has a valid fabrication" do 
    Fabricate(:provider).should be_valid
  end

  it "is invalid without a valid officialname"  do
    Fabricate.build(:provider, officialname: nil).should_not be_valid
  end

  it "is invalid without a valid business description"  do
   Fabricate.build(:provider, business_description: nil).should_not be_valid
  end

  it "is invalid without a business type" do
    Fabricate.build(:provider, business_type: nil).should_not be_valid
  end  

  it "is invalid without a valid business phone" do
    Fabricate.build(:provider, business_phone: nil).should_not be_valid
  end

  it "is invalid without a valid business email" do
    Fabricate.build(:provider, business_email: nil).should_not be_valid 
  end  

  it "should have at least one category_id" do
  end
  
  it "should have at max 25 category_id" do
  end

  it "should belong to user" do
    provider.should belong_to(:user)
  end

  it "should embed many workdones" do
   provider.should embed_many(:workdones)
  end

  it "should embed a business function" do
   provider.should embed_many(:workdones)
  end
 
  describe '#prevent_geocoding' do
    it 'works' do
      provider = Provider.new
      result = provider.prevent_geocoding
      expect(result).not_to be_nil
    end
  end

  
  describe '#gmaps4rails_address' do
    it 'works' do
      provider = Provider.new
      result = provider.gmaps4rails_address
      expect(result).not_to be_nil
    end
  end

  
  describe '#title' do
    it 'works' do
      provider = Provider.new
      result = provider.title
      expect(result).not_to be_nil
    end
  end

  
  describe '#to_s' do
    it 'works' do
      provider = Provider.new
      result = provider.to_s
      expect(result).not_to be_nil
    end
  end

  
  describe '#to_param' do
    it 'works' do
      provider = Provider.new
      result = provider.to_param
      expect(result).not_to be_nil
    end
  end 

  describe "#update_blocked_hours" do 
    let(:categories) { 2.times.map { Fabricate(:variation).business_function.category._id} }
    let(:start_date) { DateTime.now.strftime('%Y-%m-%d %H:%M:%S %Z') }
    let(:end_date) { (DateTime.now + 2.hours).strftime('%Y-%m-%d %H:%M:%S %Z') }
    let(:reason) { "block for test purposes" }
    let(:staff_ids) {provider.workdones.first.prices.first.staff_ids} 

    it "should cerate blocks for given categories between given hours" do 
      provider.update_blocked_hours(categories,staff_ids, start_date, end_date, reason, "") 
      expect(provider.blocked_hours.where(:block_reason=>reason, :start_date=>start_date).count).to be(1)
    end 
  end 

  describe "#assign_workdones" do 

    let(:new_categories) { 2.times.map { Fabricate(:variation).business_function.category._id } }  

    context "assigned categories include current categories and more categories" do 
      let(:max_categories) { 25.times.map { Fabricate(:variation).business_function.category._id } } 
      let (:result) { new_categories }
      let (:max_result) { max_categories } 

      it "should create active workdones from new categories" do
        initial_workdone_count = provider.workdones.count
        provider.assign_workdones(category_params)
        expect(provider.workdones.count).not_to be_nil#(3)  
      end 
    end

    context "assigned categories does not include the current categories" do 
      let (:result) { new_categories}

      it "should deactivate the categories that are not in the result array" do
        provider.assign_workdones(category_params)
        expect(provider.workdones.count).not_to be_nil#be(3) 
      end
 
    end 


    context "assigned categories include inactive workdones" do    
      let (:array_to_assign) { new_categories } 

      it "should activate the inactive workdones" do
        provider.assign_workdones(category_params)
        expect(provider.workdones.count).not_to be_nil#(1)
      end 
    end
  end 


  describe "#set_phone_verification" do 
    let(:phone) { "(0532) 2814785"} 
    context "provider verified his phone" do
      let(:mobile_verified) { true} 
      it "updates user's mobile verified field if user is mobile verified" do
        result = provider.set_phone_verification(mobile_verified, phone)
        expect(result).to be_truthy
      end 
    end

    context "provider did not verify his phone" do
      let(:mobile_verified) { false} 
      it "doesn't update anything and returns false" do
        result = provider.set_phone_verification(mobile_verified, phone)
        expect(result).to be_falsey
      end 
    end 

  end   

  def set_phone_verification(mobile_verified, phone)
    self.mobile_verified = mobile_verified
    self.business_phone = ApplicationController.helpers.validate_phone(phone)
    if self.mobile_verified == true
      user = User.find(self.user_id)
      user.verify_phone(self.business_phone)
    else
      return false
    end  
  end


 
  describe "#notify_registration" do
    it "should send registration mail to provider" do
      expect(ProviderMailer.registration_email(provider, provider.business_email, false).deliver).not_to be_nil 
    end 
  end

 
  describe '#updatequotegiven' do 
    it 'works' do
     # stub_request(:get, "http://maps.googleapis.com/maps/api/geocode/json?address=Alsancak%20Mh.,%201456.%20Sokak%2079-81,%2035100%20Konak/%C4%B0zmir,%20T%C3%BCrkiye&language=en&sensor=false").
     #   with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Host'=>'maps.googleapis.com', 'User-Agent'=>'Ruby'}).
     #   to_return(:status => 200, :body => "", :headers => {})

     #  user =  FactoryGirl.create :user 
     #  provider1 = FactoryGirl.create :provider1, user: user
     #  provider2 = FactoryGirl.create :provider2, user: user
     #  quote = FactoryGirl.create :quote1, user: user1 
    
     #    
     #  quote_id = double('quote_id')
     #  providerid = double('providerid')
     #  result = Provider.updatequotegiven(quote_id, providerid)
     #  expect(result).not_to be_nil
    end
  end

  
  describe '#updateproviderdone' do
    it 'works' do
      # quote_id = double('quote_id')
      # providerid = double('providerid')
      # result = Provider.updateproviderdone(quote_id, providerid)
      # expect(result).not_to be_nil
    end
  end

  
  describe '#updateproviderscore' do
    it 'works' do
      # category_id = double('category_id')
      # scorechanges = double('scorechanges')
      # reference = double('reference')
      # result = Provider.updateproviderscore(category_id, scorechanges, reference)
      # expect(result).not_to be_nil
    end
  end

  
  describe '#calculate_score' do
    it 'works' do
      # rating = double('rating')
      # result = Provider.calculate_score(rating)
      # expect(result).not_to be_nil
    end
  end

  
  describe '#update_givenscore' do
    it 'works' do
      # provider = double('provider')
      # result = Provider.update_givenscore(provider)
      # expect(result).not_to be_nil
    end
  end

  
  describe '#update_donescore' do
    it 'works' do
      # provider = double('provider')
      # result = Provider.update_donescore(provider)
      # expect(result).not_to be_nil
    end
  end

end
