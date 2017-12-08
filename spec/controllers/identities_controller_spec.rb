# -*- encoding: utf-8 -*-

require 'spec_helper'

describe IdentitiesController do

  
  describe 'GET new' do
    it 'works' do
      get :new, {}, {}
      expect(response.status).to eq(200)
    end
  end

end
