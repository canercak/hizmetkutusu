# -*- encoding: utf-8 -*-

require 'spec_helper'

describe ReferencesHelper do

  
  describe '#make_thumbs' do
    it 'works' do
      result = make_thumbs(rating)
      expect(result).not_to be_nil
    end
  end

  
  describe '#reference_tags' do
    it 'works' do
      result = reference_tags(user)
      expect(result).not_to be_nil
    end
  end

  
  describe '#get_star_rating' do
    it 'works' do
      result = get_star_rating(rating)
      expect(result).not_to be_nil
    end
  end

end
