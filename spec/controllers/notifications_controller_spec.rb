# -*- encoding: utf-8 -*-

require 'spec_helper'

describe NotificationsController do

  
  describe 'GET index' do
    it 'works' do
      get :index, {}, {}
      expect(response.status).to eq(200)
    end
  end

end
