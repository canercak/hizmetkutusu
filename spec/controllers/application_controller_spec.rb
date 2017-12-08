# -*- encoding: utf-8 -*-

require 'spec_helper'

describe ApplicationController do

  
  describe 'GET set_locale' do
    it 'works' do
      get :set_locale, {}, {}
      expect(response.status).to eq(200)
    end
  end

  
  describe 'GET getproviderworkdone' do
    it 'works' do
      get :getproviderworkdone, {}, {}
      expect(response.status).to eq(200)
    end
  end

  
  describe 'GET increment_login_count' do
    it 'works' do
      get :increment_login_count, {}, {}
      expect(response.status).to eq(200)
    end
  end

  
  describe 'GET check_verification_code' do
    it 'works' do
      get :check_verification_code, {}, {}
      expect(response.status).to eq(200)
    end
  end

  
  describe 'GET sendverification' do
    it 'works' do
      get :sendverification, {}, {}
      expect(response.status).to eq(200)
    end
  end

end
