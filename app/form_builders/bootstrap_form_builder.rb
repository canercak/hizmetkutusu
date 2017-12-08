class BootstrapFormBuilder < ActionView::Helpers::FormBuilder
  delegate :content_tag, :tag, :concat, to: :@template

  %w(text_field text_area password_field collection_select select date_select time_zone_select datetime_select).each do |method_name|
    define_method(method_name) do |name, *args|
      content_tag :div, class: "control-group#{' error' if object.errors.include?(name)}" do
        label_field(name, *args) +
        content_tag(:div, class: 'controls') do
          super(name, *args) +
          if object.errors.include?(name)
            content_tag(:span, class: 'help-inline') do
              object.errors.messages[name].join(', ')
            end
          end +
          help_field(name, *args)
        end
      end
    end
  end
  

  def default_tag(method_name, name, *args)
    self.class.superclass.instance_method(method_name).bind(self).call(name, *args)
  end
  
  def field(input_tag, attribute, options)
  errors = object.errors[attribute].uniq.to_sentence
  outer_class = errors.blank? ? 'clearfix' : 'clearfix error'
  inner_class = errors.blank? ? 'input' : 'input error'

  @template.content_tag(:div, id: "#{object.class.model_name.underscore}_#{attribute}_input", class: outer_class) do
    label(attribute, options[:label]) << @template.content_tag(:div, class: inner_class) do
      input_div = input_tag
      input_div << @template.content_tag(:span, options[:hint], class: 'help-block') if options[:hint]
      input_div << @template.content_tag(:span, errors, class: 'help-inline') if errors.present?
      input_div
    end
  end
end
  
  def file_field(attribute, options = {}, &block)  
  input_tag = block_given? ? template.capture(super, &block) : super
  input_div = input_tag
  end

  def check_box(name, *args)
    opts = args.clone.extract_options!
    l = opts.delete(:label)
    label(name, *args, class: 'checkbox') do
      super(name) + ' ' + (l || object.class.human_attribute_name(name))
    end
  end

  def radio_button(name, group, *args)
    opts = args.clone.extract_options!
    label = opts.delete(:label)
    content_tag(:label, nil, class: ['radio', opts.delete(:class)].join(' ')) do
      super(name, group, opts) + ' ' + (label || object.class.human_attribute_name(name))
    end
  end
   

  def error_messages
    if object.errors.full_messages.any?
      content_tag(:div, class: 'alert alert-block alert-error fade in') do
        concat content_tag(:button, "&times;", { class: 'close', data: { dismiss: 'alert' }, type: 'button' }, false)
        concat content_tag(:h4, I18n.t('helpers.form.error'))
        object.errors.full_messages.map do |msg|
          concat msg
          concat tag(:br)
        end
      end
    end
  end

  private
  def label_field(name, *args)
    options = args.extract_options!
    return ''.html_safe if options[:skip_label]
    required = object.class.validators_on(name).any? { |v| v.kind_of? ActiveModel::Validations::PresenceValidator }
    label(name, options[:label], class: "control-label#{' required' if required}")
  end
  
 
  
  def help_field(name, *args)
    options = args.extract_options!
    content_tag(:p, class: 'help-block') { @template.t(".#{name}_help") } if options[:help]
  end

  def objectify_options(options)
    super.except(:help)
  end
end
