# -*- encoding: utf-8 -*-

require 'spec_helper'

describe Concerns::GmapRoute do

  
  describe '#route=' do
    it 'works' do
      gmap_route = Concerns::GmapRoute.new
      param = double('param')
      result = gmap_route.route=(param)
      expect(result).not_to be_nil
    end
  end

  
  describe '#static_map' do
    it 'works' do
      gmap_route = Concerns::GmapRoute.new
      width = double('width')
      height = double('height')
      result = gmap_route.static_map(width, height)
      expect(result).not_to be_nil
    end
  end

end
