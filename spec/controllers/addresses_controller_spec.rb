# -*- encoding: utf-8 -*-

require 'spec_helper'
require './controllers/addresses_controller'

describe AddressesController do

  
  describe '#find_children' do
    it 'works' do
      addresses_controller = AddressesController.new
      result = addresses_controller.find_children
      expect(result).not_to be_nil
    end
  end

end
