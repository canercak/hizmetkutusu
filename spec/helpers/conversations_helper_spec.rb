# -*- encoding: utf-8 -*-

require 'spec_helper'

describe ConversationsHelper do

  
  describe '#message_classes' do
    it 'works' do
      result = message_classes(alternate, message, current_user)
      expect(result).not_to be_nil
    end
  end

  
  describe '#message_timestamp' do
    it 'works' do
      result = message_timestamp(message)
      expect(result).not_to be_nil
    end
  end

  
  describe '#message_readat' do
    it 'works' do
      result = message_readat(message)
      expect(result).not_to be_nil
    end
  end

  
  describe '#new_or_show_conversation_path' do
    it 'works' do
      result = new_or_show_conversation_path(conversation)
      expect(result).not_to be_nil
    end
  end

end
