# -*- encoding: utf-8 -*-

require 'spec_helper'

describe TransactionsController do

  
  describe 'GET transaction' do
    it 'works' do
      get :transaction, {}, {}
      expect(response.status).to eq(200)
    end
  end

  
  describe 'GET transparent_redirect_complete' do
    it 'works' do
      get :transparent_redirect_complete, {}, {}
      expect(response.status).to eq(200)
    end
  end

  
  describe 'GET refund_transaction' do
    it 'works' do
      get :refund_transaction, {}, {}
      expect(response.status).to eq(200)
    end
  end

  
  describe 'GET successful_purchase' do
    it 'works' do
      get :successful_purchase, {}, {}
      expect(response.status).to eq(200)
    end
  end

end
