# -*- encoding: utf-8 -*-

require 'spec_helper'

describe UsersController do

  
  describe 'GET index' do
    it 'works' do
      get :index, {}, {}
      expect(response.status).to eq(200)
    end
  end

  
  describe 'GET login_as' do
    it 'works' do
      get :login_as, {}, {}
      expect(response.status).to eq(200)
    end
  end

  
  describe 'GET ban' do
    it 'works' do
      get :ban, {}, {}
      expect(response.status).to eq(200)
    end
  end

  
  describe 'GET unban' do
    it 'works' do
      get :unban, {}, {}
      expect(response.status).to eq(200)
    end
  end

  
  describe 'GET manualcredits' do
    it 'works' do
      get :manualcredits, {}, {}
      expect(response.status).to eq(200)
    end
  end

  
  describe 'GET addcredit' do
    it 'works' do
      get :addcredit, {}, {}
      expect(response.status).to eq(200)
    end
  end

  
  describe 'GET refunds' do
    it 'works' do
      get :refunds, {}, {}
      expect(response.status).to eq(200)
    end
  end

end
