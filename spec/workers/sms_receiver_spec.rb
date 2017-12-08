# -*- encoding: utf-8 -*-

require 'spec_helper'

describe SmsReceiver do
 
  describe '#perform' do
    it 'works' do
      result = SmsReceiver.perform
      expect(result).not_to be_nil
    end
  end

end
