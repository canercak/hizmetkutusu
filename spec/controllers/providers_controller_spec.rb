# -*- encoding: utf-8 -*-

require 'spec_helper'

describe ProvidersController do
  login
  render_views



  
  describe 'GET quotes' do
    it 'works' do
      get :quotes, {}, {}
      expect(response.status).to eq(200)
    end
  end

  
  describe 'GET prices' do
    it 'works' do
      get :prices, {}, {}
      expect(response.status).to eq(200)
    end
  end

  
  describe 'GET check_phone' do
    it 'works' do
      get :check_phone, {}, {}
      expect(response.status).to eq(200)
    end
  end

  
  describe 'GET check_email' do
    it 'works' do
      get :check_email, {}, {}
      expect(response.status).to eq(200)
    end
  end

  
  describe 'GET check_pin' do
    it 'works' do
      get :check_pin, {}, {}
      expect(response.status).to eq(200)
    end
  end

  
  describe 'GET check_tax_number' do
    it 'works' do
      get :check_tax_number, {}, {}
      expect(response.status).to eq(200)
    end
  end

  
  describe 'GET getprovideraddress' do
    it 'works' do
      get :getprovideraddress, {}, {}
      expect(response.status).to eq(200)
    end
  end

  
  describe 'GET getlocation' do
    it 'works' do
      get :getlocation, {}, {}
      expect(response.status).to eq(200)
    end
  end

  
  describe 'GET new' do
    it 'works' do
      get :new, {}, {}
      expect(response.status).to eq(200)
    end
  end

  
  describe 'GET index' do
    it 'works' do
      get :index, {}, {}
      expect(response.status).to eq(200)
    end
  end

  
  describe 'GET show' do
    it 'works' do
      get :show, {}, {}
      expect(response.status).to eq(200)
    end
  end

  
  describe 'GET getprovider' do
    it 'works' do
      get :getprovider, {}, {}
      expect(response.status).to eq(200)
    end
  end

  
  describe 'GET getuserproviders' do
    it 'works' do
      get :getuserproviders, {}, {}
      expect(response.status).to eq(200)
    end
  end

  
  describe 'POST create' do
    context "when model is invalid" do 
      let(:data) { "params"}

      context "html" do 
       let(:perform) { post :create, data }

       it "renders the form with data entered" do 
        perform
        response.should redirect_to
       end 

      end




      post :create, {}, {}
      expect(response.status).to eq(200)
    end
  end

  
  describe 'GET edit' do
    it 'works' do
      get :edit, {}, {}
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

  
  describe 'GET search' do
    it 'works' do
      get :search, {}, {}
      expect(response.status).to eq(200)
    end
  end

end
