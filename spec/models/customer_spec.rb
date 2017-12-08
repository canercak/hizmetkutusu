require 'spec_helper'
 
describe Customer do
  let(:variation) { Fabricate(:variation) }
  let(:provider)  { Fabricate(:price, variation_id: variation._id).workdone.provider }
  let(:customer) { Fabricate(:customer, provider: provider, user_id: provider.user._id)}
  
  it "has a valid fabrication" do 
    Fabricate(:customer, provider: provider, user_id: provider.user._id).should be_valid
  end 

  describe '#save_new' do
 
    context 'save customer' do
          let(:params) { {:email=>"canercak@gmail.com", 
                    :phone=>"(0532) 2824781",
                    :name =>"John Millier",
                    :person_type=> 0,
                    :address=>"İstanbul Bostanlı 1763" }}
      it "should save customer  who is not in the system successfully" do
        expect(Customer.save_new(provider,customer.user_id, params)).not_to be_nil
      end 
    end
    context 'save staff member' do
          let(:params) { {:email=>"canercak@gmail.com", 
                    :phone=>"(0532) 2814781",
                    :name =>"John Millier",
                    :person_type=> 1,
                    :address=>"İstanbul Bostanlı 1763" }}
      it "should save staff member who is not in the system successfully" do
        expect(Customer.save_new(provider,customer.user_id, params)).not_to be_nil
      end 
    end 

  end
  

end
