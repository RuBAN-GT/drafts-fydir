module ApplicationHelper
  # Handle resource messages
  def error_resource_message(resource, field)
    if resource.errors[field.to_sym].any?
      output = resource.errors.full_messages_for(field.to_sym).join('. ')

      content_tag :div, output, :class => "ui basic negative pointing prompt label"
    end
  end

  # Get icon tag
  def icon(name, options = {})
    content_tag :i, "", :class => "icon #{options[:class].to_s} #{name.to_s}"
  end

  # Get controller & action target script
  def target_scripts
    result = ''

    controller_path = "#{params[:controller]}"
    controller_path.insert (controller_path.rindex('/').to_i + 1), 'targets/'

    if File.exist? Rails.root.join('app', 'assets', 'javascripts', "#{controller_path}.js.coffee")
      result += javascript_include_tag("#{controller_path}", 'data-turbolinks-track': 'reload')
    end
    if File.exist? Rails.root.join('app', 'assets', 'javascripts', "#{controller_path}_#{params[:action]}.js.coffee")
      result += javascript_include_tag("#{controller_path}_#{params[:action]}", 'data-turbolinks-track': 'reload')
    end

    result.html_safe
  end

  def controller_classes
    params[:controller].gsub('/', '_')
  end
end
