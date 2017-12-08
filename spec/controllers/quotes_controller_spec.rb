# -*- encoding: utf-8 -*-

require 'spec_helper'

describe QuotesController do
  def login
    @user = Fabricate :user, uid: '123456', gender: 'female'
    @old_mocked_authhash = OMNIAUTH_MOCKED_AUTHHASH
    OmniAuth.config.mock_auth[:facebook] = OMNIAUTH_MOCKED_AUTHHASH.merge extra: { raw_info: { gender: 'female' } }
    visit '/auth/facebook'
    OmniAuth.config.mock_auth[:facebook] = @old_mocked_authhash
  end


  
  describe 'GET getaddress' do
    it 'works' do
      get :getaddress, {}, {}
      expect(response.status).to eq(200)
    end
  end

  
  describe 'GET providers' do
    it 'works' do
      get :providers, {}, {}
      expect(response.status).to eq(200)
    end
  end

  
  describe 'GET give' do
    it 'works' do
      get :give, {}, {}
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

  
  describe 'GET getselectedproviders' do
    it 'works' do
      get :getselectedproviders, {}, {}
      expect(response.status).to eq(200)
    end
  end

  
  describe 'POST create' do 

    before :each do 
      login
      @quote_attributes = Fabricate.attributes_for(:quote)
    end

    context "given there are valid params" do

      it 'should redirect to quote show page with a notice on successful save', js: true do
          expect {
            post :create, :quote=>@quote
          }.to change(Quote, :count).by(1)
  
         quote = assigns(:quote)
         response.should redirect_to quote_path(quote) 
      end  
      it 'should re-render new template on failed save' do
      end

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

end
