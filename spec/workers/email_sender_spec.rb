# -*- encoding: utf-8 -*-

require 'spec_helper'

describe EmailSender do

 
  describe '#perform' do
    it 'works' do
      mailer = double('mailer')
      method = double('method')
      user_id = double('user_id')
      result = EmailSender.perform(mailer, method, user_id)
      expect(result).not_to be_nil
    end
  end

end
