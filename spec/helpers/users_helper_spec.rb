# -*- encoding: utf-8 -*-

require 'spec_helper'

describe UsersHelper do

  
  describe '#facebook_profile_picture' do
    it 'works' do
      result = facebook_profile_picture(user, type)
      expect(result).not_to be_nil
    end
  end

  
  describe '#user_transactions' do
    it 'works' do
      result = user_transactions
      expect(result).not_to be_nil
    end
  end

  
  describe '#user_profile_picture' do
    it 'works' do
      result = user_profile_picture(user, size:[50, 50], type::square, style:'img-polaroid', opts:{})
      expect(result).not_to be_nil
    end
  end

  
  describe '#navbar_notifications' do
    it 'works' do
      result = navbar_notifications(title, opts)
      expect(result).not_to be_nil
    end
  end

  
  describe '#friends_with_privacy' do
    it 'works' do
      result = friends_with_privacy(friends)
      expect(result).not_to be_nil
    end
  end

  
  describe '#mutual_friends' do
    it 'works' do
      result = mutual_friends(user1, user2, limit)
      expect(result).not_to be_nil
    end
  end

  
  describe '#check_common_field' do
    it 'works' do
      result = check_common_field(user, field)
      expect(result).not_to be_nil
    end
  end

  
  describe '#language_tags' do
    it 'works' do
      result = language_tags(user)
      expect(result).not_to be_nil
    end
  end

  
  describe '#work_and_education_tags' do
    it 'works' do
      result = work_and_education_tags(user, field)
      expect(result).not_to be_nil
    end
  end

  
  describe '#favorite_tags' do
    it 'works' do
      result = favorite_tags(user, user_favorites)
      expect(result).not_to be_nil
    end
  end

  
  describe '#quote_tags' do
    it 'works' do
      result = quote_tags(user)
      expect(result).not_to be_nil
    end
  end

  
  describe '#quote_tag' do
    it 'works' do
      result = quote_tag(user, quote_type)
      expect(result).not_to be_nil
    end
  end

end
