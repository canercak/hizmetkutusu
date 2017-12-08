# -*- encoding: utf-8 -*-

require 'spec_helper'

describe CategoriesController do

  
  describe 'GET list_styles' do
    it 'works' do
      get :list_styles, {}, {}
      expect(response.status).to eq(200)
    end
  end

end
