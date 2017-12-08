# -*- encoding: utf-8 -*-

require 'spec_helper'

describe PagesController do

  
  describe 'GET home' do
    it 'works' do
      get :home, {}, {}
      expect(response.status).to eq(200)
    end
  end

  
  describe 'GET fbjssdk_channel' do
    it 'works' do
      get :fbjssdk_channel, {}, {}
      expect(response.status).to eq(200)
    end
  end

end
