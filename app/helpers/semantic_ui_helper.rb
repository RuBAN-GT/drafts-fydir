module SemanticUiHelper
  def semantic_select(method, data, options = {})
    options = {
      :icon => 'caret right',
      :class => '',
      :include_blank => t('template.choice'),
      :name => :name,
      :id => :id,
      :multiple => false,
    }.merge options

    content_tag :div, :class => "ui #{method} selection #{options[:multiple] ? "multiple" : ""} #{options[:class]} #{'icon' if options[:icon]} dropdown" do
      output =  hidden_field_tag method, params[method]
      output += icon options[:icon]
      output += content_tag :div, options[:include_blank], :class => 'default text' if options[:include_blank]
      output += content_tag :div, :class => :menu do
        result = ''.html_safe

        blank = options[:option_blank] || options[:include_blank]

        result << content_tag(:div, blank, :class => 'item', 'data-value' => 0).html_safe if blank

        result << data.map { |p|
          id   = p.respond_to?(options[:id]) ? p.send(options[:id]) : p[options[:id]]
          name = p.respond_to?(options[:name]) ? p.send(options[:name]) : p[options[:name]]

          content_tag :div,
            name,
            :class => "item #{'active selected' if params[method] == id}",
            'data-value' => id
        }.join($/).html_safe
      end

      output
    end
  end
end
