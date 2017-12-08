# -*- encoding: utf-8 -*-

require 'spec_helper'

describe ActivitiesController do

  
  describe 'GET index' do
    it 'works' do
      get :index, {}, {}
      expect(response.status).to eq(200)
    end
  end

  
  describe 'GET get_provider_counts' do
    it 'works' do
      get :get_provider_counts, {}, {}
      expect(response.status).to eq(200)
    end
  end

  
  describe 'GET get_activity' do
    it 'works' do
      get :get_activity, {}, {}
      expect(response.status).to eq(200)
    end
  end

end
