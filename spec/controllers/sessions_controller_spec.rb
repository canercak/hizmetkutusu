# -*- encoding: utf-8 -*-

require 'spec_helper'

describe SessionsController do

  
  describe 'POST create' do
    it 'works' do
      post :create, {}, {}
      expect(response.status).to eq(200)
    end
  end

  
  describe 'DELETE destroy' do
    it 'works' do
      delete :destroy, {}, {}
      expect(response.status).to eq(200)
    end
  end

  
  describe 'GET failure' do
    it 'works' do
      get :failure, {}, {}
      expect(response.status).to eq(200)
    end
  end

  
  describe 'GET new' do
    it 'works' do
      get :new, {}, {}
      expect(response.status).to eq(200)
    end
  end

end
