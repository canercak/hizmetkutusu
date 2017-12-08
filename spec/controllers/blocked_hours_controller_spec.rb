# -*- encoding: utf-8 -*-

require 'spec_helper'
require './controllers/blocked_hours_controller'

describe BlockedHoursController do

  
  describe '#save' do
    it 'works' do
      blocked_hours_controller = BlockedHoursController.new
      result = blocked_hours_controller.save
      expect(result).not_to be_nil
    end
  end

end
