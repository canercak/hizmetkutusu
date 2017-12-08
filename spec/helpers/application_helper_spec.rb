# -*- encoding: utf-8 -*-

require 'spec_helper'

describe ApplicationHelper do

  
  describe '#payment_array' do
    it 'works' do
      result = payment_array
      expect(result).not_to be_nil
    end
  end

  
  describe '#title' do
    it 'works' do
      result = title(page_title)
      expect(result).not_to be_nil
    end
  end

  
  describe '#get_first_name' do
    it 'works' do
      result = get_first_name(string)
      expect(result).not_to be_nil
    end
  end

  
  describe '#verified' do
    it 'works' do
      result = verified(providerid)
      expect(result).not_to be_nil
    end
  end

  
  describe '#validate_phone' do
    it 'works' do
      result = validate_phone(phone)
      expect(result).not_to be_nil
    end
  end

  
  describe '#yield_or_default' do
    it 'works' do
      result = yield_or_default(section, default)
      expect(result).not_to be_nil
    end
  end

  
  describe '#twitterized_type' do
    it 'works' do
      result = twitterized_type(type)
      expect(result).not_to be_nil
    end
  end

  
  describe '#transparent_gif_image_data' do
    it 'works' do
      result = transparent_gif_image_data
      expect(result).not_to be_nil
    end
  end

  
  describe '#bootstrap_form_for' do
    it 'works' do
      result = bootstrap_form_for(object, options, &block)
      expect(result).not_to be_nil
    end
  end

  
  describe '#options_for_array_collection' do
    it 'works' do
      result = options_for_array_collection(model, attr_name, *args)
      expect(result).not_to be_nil
    end
  end

  
  describe '#background_jobs_available?' do
    it 'works' do
      result = background_jobs_available?
      expect(result).not_to be_nil
    end
  end

end
