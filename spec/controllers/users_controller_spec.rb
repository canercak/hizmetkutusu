# -*- encoding: utf-8 -*-

require 'spec_helper'

describe UsersController do

  
  describe 'GET show' do
    it 'works' do
      get :show, {}, {}
      expect(response.status).to eq(200)
    end
  end

  
  describe 'GET edit' do
    it 'works' do
      get :edit, {}, {}
      expect(response.status).to eq(200)
    end
  end

  
  describe 'GET check_email' do
    it 'works' do
      get :check_email, {}, {}
      expect(response.status).to eq(200)
    end
  end

  
  describe 'PUT update' do
    it 'works' do
      put :update, {}, {}
      expect(response.status).to eq(200)
    end
  end

  
  describe 'DELETE destroy' do
    it 'works' do
      delete :destroy, {}, {}
      expect(response.status).to eq(200)
    end
  end

  
  describe 'GET dashboard' do
    it 'works' do
      get :dashboard, {}, {}
      expect(response.status).to eq(200)
    end
  end

  
  describe 'GET financialsettings' do
    it 'works' do
      get :financialsettings, {}, {}
      expect(response.status).to eq(200)
    end
  end

  
  describe 'GET references' do
    it 'works' do
      get :references, {}, {}
      expect(response.status).to eq(200)
    end
  end

  
  describe 'GET quotes' do
    it 'works' do
      get :quotes, {}, {}
      expect(response.status).to eq(200)
    end
  end

  
  describe 'GET providers' do
    it 'works' do
      get :providers, {}, {}
      expect(response.status).to eq(200)
    end
  end

  
  describe 'GET banned' do
    it 'works' do
      get :banned, {}, {}
      expect(response.status).to eq(200)
    end
  end

end
