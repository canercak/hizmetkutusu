# -*- encoding: utf-8 -*-

require 'spec_helper'

describe ProvidersHelper do

  
  describe '#business_type_options' do
    it 'works' do
      result = business_type_options
      expect(result).not_to be_nil
    end
  end

  
  describe '#show_business_type' do
    it 'works' do
      result = show_business_type(type)
      expect(result).not_to be_nil
    end
  end

  
  describe '#getShortAddress' do
    it 'works' do
      result = getShortAddress(location)
      expect(result).not_to be_nil
    end
  end

  
  describe '#boolean_tag' do
    it 'works' do
      result = boolean_tag(value, field)
      expect(result).not_to be_nil
    end
  end

  
  describe '#user_view?' do
    it 'works' do
      result = user_view?
      expect(result).not_to be_nil
    end
  end

  
  describe '#prepare_provider' do
    it 'works' do
      result = prepare_provider( workdone, lat, lon, select, rowindex)
      expect(result).not_to be_nil
    end
  end

  
  describe '#transloadit_provider_images' do
    it 'works' do
      result = transloadit_provider_images(params, images)
      expect(result).not_to be_nil
    end
  end

end
