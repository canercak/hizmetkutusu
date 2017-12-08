 
require 'spec_helper'
 
describe BlockedHour do

  let(:variation) { Fabricate(:variation) }
  let(:provider)  { Fabricate(:price,  variation_id: variation._id).workdone.provider }
  let(:start_date) {Time.zone.now.beginning_of_day + 8.hours }
  let(:end_date) {Time.zone.now.beginning_of_day + 12.hours }
  let(:prices)  { provider.workdones.map{|w| w.prices.map { |p| p._id}}.reduce(:+) }
  let(:staff_ids) { [Fabricate(:customer, provider: provider, person_type: 1).user_id ]}
  let(:quote) {Fabricate(:quote, variation_id: [variation._id], providers: [provider]) }
  # let(:event) {Fabricate(:event, provider: provider, quote: quote, variation_ids: [variation._id],  
  #                        start_date: start_date, end_date: end_date)}  

  def define_provider
    category_id = variation.business_function.category._id
    provider.workdones.first.category_id = category_id
    provider.save 
    @@reservation =   Fabricate(:reservation, price_ids: prices,   quote: quote, start_date: start_date, end_date: end_date, staff_ids: staff_ids)   
    @@blocked_hour = Fabricate(:blocked_hour, provider: provider, category_id: [category_id], staff_ids: staff_ids,  start_date: start_date, end_date: end_date)  
   end
 

   before(:each) do
    define_provider
   end

  describe '#get_blocks' do  
     it 'should return blocked and reserved hours of a date range with work duration of a single service' do 
      expected =  [{start_date.to_date => [@@blocked_hour]}, {start_date.to_date => [@@reservation]}, 60] 
      result = BlockedHour.get_blocks(provider, prices, start_date, end_date) 
      expect(result).to eq expected 
    end
  end

  describe '#blocked_days' do
    it 'works' do
     
      result = BlockedHour.blocked_days(provider, prices)
      expect(result).not_to be_nil
    end
  end

  
  describe '#iterate_blocks' do
    it 'works' do  
      bh_active = true
      blocked_date = [provider.blocked_hours.first]
      bday_range = ApplicationController.helpers.get_business_day_range(start_date, "08:00", "18:00")  
      bday_f = bday_range.to_a.first.first.to_i
      bday_l = bday_range.to_a.first.last.to_i 
      work_dur = 60
      result = BlockedHour.iterate_blocks(bh_active, blocked_date, bday_range, bday_f, bday_l, work_dur)
      expect(result).not_to be_nil
    end
  end

  
  describe '#iterate_reserved' do
    it 'works' do 
     
      bh_active = true
      reserved_date = [quote.reservations.first]
      bday_range = ApplicationController.helpers.get_business_day_range(start_date, "08:00", "18:00")  
      bday_f = bday_range.to_a.first.first.to_i
      bday_l = bday_range.to_a.first.last.to_i 
      work_dur = 60
      result = BlockedHour.iterate_reserved(bh_active, reserved_date, bday_range, bday_f, bday_l, work_dur)
      expect(result).not_to be_nil
    end
  end

  
  describe '#iterate_multiple' do
    it 'works' do 
      bh_active = true
      blocked_date = [provider.blocked_hours.first]
      reserved_date = [quote.reservations.first]
      bday_range = ApplicationController.helpers.get_business_day_range(start_date, "08:00", "18:00")  
      bday_f = bday_range.to_a.first.first.to_i
      bday_l = bday_range.to_a.first.last.to_i 
      work_dur = 60
      result = BlockedHour.iterate_multiple(bh_active, blocked_date, reserved_date, bday_range, bday_f, bday_l, work_dur)
      expect(result).not_to be_nil
    end
  end

  
  describe '#range_withgaps' do
    it 'works' do 
      blocked_date = [provider.blocked_hours.first]
      result = BlockedHour.range_withgaps(blocked_date)
      expect(result).not_to be_nil
    end
  end

  
  describe '#get_available_hours' do
    it 'works' do 
      date = Time.now.to_date
      result = BlockedHour.get_available_hours(provider, prices, date)
      expect(result).not_to be_nil
    end
  end


  describe '#match_business_hours' do
    it "should match_business_hours" do
      result = BlockedHour.match_business_hours(provider, @@blocked_hour.to_a, start_date, end_date)
      expect(result).not_to be_nil
    end 
  end

  
  describe '#find_available_hours' do
    it 'works' do 
      blocked_date = [provider.blocked_hours.first]
      reserved_date = [quote.reservations.first] 
      blocked_range = BlockedHour.range_withgaps(blocked_date) 
      reserved_range = BlockedHour.range_withgaps(reserved_date) 
      all_range = blocked_range  | reserved_range 
      bday_range = ApplicationController.helpers.get_business_day_range(start_date, "08:00", "18:00")  
      bday_f = bday_range.to_a.first.first.to_i
      bday_l = bday_range.to_a.first.last.to_i 
      work_dur = 60 
      result = BlockedHour.find_available_hours(all_range, bday_f, bday_l, work_dur)
      expect(result).not_to be_nil
    end
  end
 

end
