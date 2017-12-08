# -*- encoding: utf-8 -*-

require 'spec_helper'
require './helpers/blocked_hours_helper'

describe BlockedHoursHelper do

  
  describe '#calculate_date_range' do
    it 'works' do
      blocked_hours_helper = BlockedHoursHelper.new
      result = blocked_hours_helper.calculate_date_range
      expect(result).not_to be_nil
    end
  end

  
  describe '#check_duration_ok' do
    it 'works' do
      blocked_hours_helper = BlockedHoursHelper.new
      bday_duration = double('bday_duration')
      work_duration = double('work_duration')
      duration = double('duration')
      result = blocked_hours_helper.check_duration_ok(bday_duration, work_duration, duration)
      expect(result).not_to be_nil
    end
  end

  
  describe '#get_business_day_range' do
    it 'works' do
      blocked_hours_helper = BlockedHoursHelper.new
      date = double('date')
      from = double('from')
      till = double('till')
      result = blocked_hours_helper.get_business_day_range(date, from, till)
      expect(result).not_to be_nil
    end
  end

  
  describe '#half_hour_to_s' do
    it 'works' do
      blocked_hours_helper = BlockedHoursHelper.new
      available_hours = double('available_hours')
      result = blocked_hours_helper.half_hour_to_s(available_hours)
      expect(result).not_to be_nil
    end
  end

end
