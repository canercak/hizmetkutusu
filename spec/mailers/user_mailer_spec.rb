# -*- encoding: utf-8 -*-

require 'spec_helper'

describe UserMailer do

  
  describe '#welcome_email' do
    it 'works' do
      user_mailer = UserMailer.new
      user = double('user')
      result = user_mailer.welcome_email(user)
      expect(result).not_to be_nil
    end
  end

  
  describe '#comment_email' do
    it 'works' do
      user_mailer = UserMailer.new
      quote = double('quote')
      result = user_mailer.comment_email(quote)
      expect(result).not_to be_nil
    end
  end

end
