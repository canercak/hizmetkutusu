# -*- encoding: utf-8 -*-

require 'spec_helper'
 
describe Quote do
 
  describe '#prevent_geocoding' do
    it 'works' do
      quote = Quote.new
      result = quote.prevent_geocoding
      expect(result).not_to be_nil
    end
  end
 
  describe '#gmaps4rails_address' do
    it 'works' do
      quote = Quote.new
      result = quote.gmaps4rails_address
      expect(result).not_to be_nil
    end
  end
 
  describe '#notify_provider' do
    it 'works' do
      quote = Fabricate(:quote)
      result = Quote.notify_provider(quote)      
      expect(result).not_to be_nil
    end
  end
 
  describe '#prepare_sms_message' do
    it 'should return phone and sms message of a quote provider' do
       quote = Fabricate(:quote) 
       quote.providers.each do |provider|
         expect(provider.business_phone.to_i).to be > 999999999
         result = Quote.prepare_message(provider, quote)
         expect(result).not_to be_nil 
         expect(result).to match /sizden/
      end
    end
  end
 
  describe '#give_quote' do
    it 'works' do
      quote = Fabricate(:quote)
      provider = quote.providers.first
      result = Quote.give_quote(quote, provider)
      expect(result).not_to be_nil
    end
  end

end
