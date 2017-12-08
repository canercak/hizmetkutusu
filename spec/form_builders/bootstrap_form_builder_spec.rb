# -*- encoding: utf-8 -*-

require 'spec_helper'

describe BootstrapFormBuilder do

  
  describe '#default_tag' do
    it 'works' do
      bootstrap_form_builder = BootstrapFormBuilder.new
      method_name = double('method_name')
      name = double('name')
      *args = double('*args')
      result = bootstrap_form_builder.default_tag(method_name, name, *args)
      expect(result).not_to be_nil
    end
  end

  
  describe '#field' do
    it 'works' do
      bootstrap_form_builder = BootstrapFormBuilder.new
      input_tag = double('input_tag')
      attribute = double('attribute')
      options = double('options')
      result = bootstrap_form_builder.field(input_tag, attribute, options)
      expect(result).not_to be_nil
    end
  end

  
  describe '#file_field' do
    it 'works' do
      bootstrap_form_builder = BootstrapFormBuilder.new
      attribute = double('attribute')
      options = double('options')
      &block = double('&block')
      result = bootstrap_form_builder.file_field(attribute, options, &block)
      expect(result).not_to be_nil
    end
  end

  
  describe '#check_box' do
    it 'works' do
      bootstrap_form_builder = BootstrapFormBuilder.new
      name = double('name')
      *args = double('*args')
      result = bootstrap_form_builder.check_box(name, *args)
      expect(result).not_to be_nil
    end
  end

  
  describe '#radio_button' do
    it 'works' do
      bootstrap_form_builder = BootstrapFormBuilder.new
      name = double('name')
      group = double('group')
      *args = double('*args')
      result = bootstrap_form_builder.radio_button(name, group, *args)
      expect(result).not_to be_nil
    end
  end

  
  describe '#error_messages' do
    it 'works' do
      bootstrap_form_builder = BootstrapFormBuilder.new
      result = bootstrap_form_builder.error_messages
      expect(result).not_to be_nil
    end
  end

end
