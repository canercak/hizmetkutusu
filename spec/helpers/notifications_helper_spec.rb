# -*- encoding: utf-8 -*-

require 'spec_helper'

describe NotificationsHelper do

  
  describe '#notification_message' do
    it 'works' do
      result = notification_message(notification)
      expect(result).not_to be_nil
    end
  end

  
  describe '#notification_icon' do
    it 'works' do
      result = notification_icon(notification)
      expect(result).not_to be_nil
    end
  end

end
