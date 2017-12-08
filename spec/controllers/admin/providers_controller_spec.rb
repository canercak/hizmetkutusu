# -*- encoding: utf-8 -*-

require 'spec_helper'

describe ProvidersController do

  
  describe 'GET index' do
    it 'works' do
      get :index, {}, {}
      expect(response.status).to eq(200)
    end
  end

  
  describe 'GET verify' do
    it 'works' do
      get :verify, {}, {}
      expect(response.status).to eq(200)
    end
  end

  
  describe 'GET unverify' do
    it 'works' do
      get :unverify, {}, {}
      expect(response.status).to eq(200)
    end
  end

end
