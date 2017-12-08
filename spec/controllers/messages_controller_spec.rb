# -*- encoding: utf-8 -*-

require 'spec_helper'

describe MessagesController do

  
  describe 'POST create' do
    it 'works' do
      post :create, {}, {}
      expect(response.status).to eq(200)
    end
  end

end
