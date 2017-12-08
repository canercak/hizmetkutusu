# -*- encoding: utf-8 -*-

require 'spec_helper'

describe QuotesHelper do

  
  describe '#boolean_options_for_select' do
    it 'works' do
      result = boolean_options_for_select
      expect(result).not_to be_nil
    end
  end

  
  describe '#default_leave_date' do
    it 'works' do
      result = default_leave_date
      expect(result).not_to be_nil
    end
  end

  
  describe '#boolean_tag' do
    it 'works' do
      result = boolean_tag(value, field)
      expect(result).not_to be_nil
    end
  end

  
  describe '#user_provider_phones' do
    it 'works' do
      result = user_provider_phones
      expect(result).not_to be_nil
    end
  end

  
  describe '#get_quote_reference' do
    it 'works' do
      result = get_quote_reference(quote)
      expect(result).not_to be_nil
    end
  end

  
  describe '#find_category' do
    it 'works' do
      result = find_category(category_id)
      expect(result).not_to be_nil
    end
  end

  
  describe '#share_on_facebook_timeline_checkbutton' do
    it 'works' do
      result = share_on_facebook_timeline_checkbutton(form)
      expect(result).not_to be_nil
    end
  end

  
  describe '#list_selected_providers' do
    it 'works' do
      result = list_selected_providers(quote)
      expect(result).not_to be_nil
    end
  end

end
