# -*- encoding: utf-8 -*-

require 'spec_helper'
require './controllers/workdones_controller'

describe WorkdonesController do

  
  describe '#index' do
    it 'works' do
      workdones_controller = WorkdonesController.new
      result = workdones_controller.index
      expect(result).not_to be_nil
    end
  end

  
  describe '#new' do
    it 'works' do
      workdones_controller = WorkdonesController.new
      result = workdones_controller.new
      expect(result).not_to be_nil
    end
  end

  
  describe '#create' do
    it 'works' do
      workdones_controller = WorkdonesController.new
      result = workdones_controller.create
      expect(result).not_to be_nil
    end
  end

  
  describe '#show' do
    it 'works' do
      workdones_controller = WorkdonesController.new
      result = workdones_controller.show
      expect(result).not_to be_nil
    end
  end

  
  describe '#update' do
    it 'works' do
      workdones_controller = WorkdonesController.new
      result = workdones_controller.update
      expect(result).not_to be_nil
    end
  end

  
  describe '#update_all' do
    it 'finds provider workdones' do
      #workdones_controller = WorkdonesController.new
      #saved.should equal(true)
      #provider = Fabricate(:workdone).provider
      #workdone = provider.workdone 
      #workdones_controller.params['workdone'].should_not be_nil
      #put :update_all, :workdone=>  {workdone.id=>
                                    #{"give_price"=>"1",
                                     #"price0"=>"43",
                                     #"discount0"=>"23",
                                     #"price1"=>"12",
                                     #"discount1"=>"32"}}
      #params['workdone'].keys.each_with_index do |id, index|
      
      #end
 
##{"utf8"=>"✓",
 ##"_method"=>"put",
 ##"authenticity_token"=>"FrEXIyop/47cpHR6jnLLSAIJIKg1lnLYv0jDHq9CJW0=",
 ##"workdone"=>
  ##{"53777a3f63616e7174020000"=>
    ##{"give_price"=>"1",
     ##"price0"=>"43",
     ##"discount0"=>"23",
     ##"price1"=>"12",
     ##"discount1"=>"32"},
   ##"53777a3f63616e7174060000"=>
    ##{"give_price"=>"1",
     ##"price0"=>"45",
     ##"discount0"=>"32",
     ##"price1"=>"50",
     ##"discount1"=>"0"},
   ##"53777a3f63616e7174090000"=>
    ##{"give_price"=>"0", "price0"=>"90", "discount0"=>"0"}},
 ##"commit"=>"Kaydet",
 ##"action"=>"update_all",
 ##"controller"=>"workdones",
 ##"locale"=>"tr",
 ##"id"=>
  ##"dsssss-dsads-dsadsad-sad-sd-sa-alsancak-mh-dot-1456-sokak-no-92-35100-konak-slash-izmir-turkiye"}


      
      #result = workdones_controller.update_all
      #expect(result).not_to be_nil
    end
  end

end
