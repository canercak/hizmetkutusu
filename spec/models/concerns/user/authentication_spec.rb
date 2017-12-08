# -*- encoding: utf-8 -*-

require 'spec_helper'

describe Concerns::User::Authentication::ClassMethods do

  
  describe '#from_omniauth' do
    it 'works' do
      class_methods = Concerns::User::Authentication::ClassMethods.new
      auth = double('auth')
      result = class_methods.from_omniauth(auth)
      expect(result).not_to be_nil
    end
  end

end
