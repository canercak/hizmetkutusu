# -*- encoding: utf-8 -*-

require 'spec_helper'

describe ProviderMailer do

  
  describe '#registration_email' do
    it 'works' do
      provider_mailer = ProviderMailer.new
      provider = double('provider')
      result = provider_mailer.registration_email(provider)
      expect(result).not_to be_nil
    end
  end

  
  describe '#new_quote_email' do
    it 'works' do
      provider_mailer = ProviderMailer.new
      quote = double('quote')
      result = provider_mailer.new_quote_email(quote)
      expect(result).not_to be_nil
    end
  end

  
  describe '#return_quote_email' do
    it 'works' do
      provider_mailer = ProviderMailer.new
      quote = double('quote')
      provider = double('provider')
      result = provider_mailer.return_quote_email(quote, provider)
      expect(result).not_to be_nil
    end
  end

  
  describe '#credit_email' do
    it 'works' do
      provider_mailer = ProviderMailer.new
      provider = double('provider')
      result = provider_mailer.credit_email(provider)
      expect(result).not_to be_nil
    end
  end

end
