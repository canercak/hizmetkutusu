# -*- encoding: utf-8 -*-

require 'spec_helper'

describe Sms do

  
  describe '#build_xml' do
    it 'works' do
      # sms = Sms.new
      # phone_array = double('phone_array')
      # message_array = double('message_array')
      # result = sms.build_xml(phone_array, message_array)
      # expect(result).not_to be_nil
    end
  end

  
  describe '#send_single_sms' do
    it 'works' do
      # sms = Sms.new
      # phone = double('phone')
      # message = double('message')
      # return_word = double('return_word')
      # type = double('type')
      # quote_id = double('quote_id')
      # result = sms.send_single_sms(phone, message, return_word, type, quote_id)
      # expect(result).not_to be_nil
    end
  end

  
  describe '#send_multi_sms' do
    it 'works' do
      # sms = Sms.new
      # phone_array = double('phone_array')
      # message_array = double('message_array')
      # return_word_array = double('return_word_array')
      # type = double('type')
      # quote_id = double('quote_id')
      # result = sms.send_multi_sms(phone_array, message_array, return_word_array, type, quote_id)
      # expect(result).not_to be_nil
    end
  end

  
  describe '#check_incoming_sms' do
    it 'works' do
      sms = Sms.new
      result = sms.check_incoming_sms
      expect(result).not_to be_nil
    end
  end

  
  describe '#answer_to_incoming' do
    it 'works' do
      # sms = Sms.new
      # # incoming = double('incoming')
      # result = sms.answer_to_incoming(incoming)
      # expect(result).not_to be_nil
    end
  end

  
  describe '#match_freq' do
    it 'works' do
      # sms = Sms.new
      # exprs = double('exprs')
      # strings = double('strings')
      # result = sms.match_freq(exprs, strings)
      # expect(result).not_to be_nil
    end
  end

  
  describe '#add' do
    it 'works' do
      # sms = Sms.new
      # key_value = double('key_value')
      # result = sms.add(key_value)
      # expect(result).not_to be_nil
    end
  end

end
