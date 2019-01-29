module PlatformsHelper
  # Show platform label
  def platform_label(platform, options = {})
    case platform.slug.to_sym
      when :ps3, :ps4
        color = 'blue'
      when :xboxone, :xbox360
        color = 'green'
      else
        color = 'basic'
    end

    content_tag :div, "#{icon :cubes} #{platform.name}".html_safe, :class => "ui #{color} #{options[:class]} platform label", "data-slug" => platform.slug.downcase if platform.present?
  end

  # Show platform select
  def platform_tag(method = :platform, html_options = {})
    html_options = {
      :id => :slug,
      :class => 'search',
      :icon => :cubes,
      :include_blank => t('template.platforms.all')
    }.merge html_options

    semantic_select method,
      Platform.order(html_options[:id] => :asc),
      html_options
  end
end

class ActionView::Helpers::FormBuilder
  def platform(method = :platform, options = {}, html_options = {})
    options = {
      :selected => (object && object.platform && object.platform.id)
    }.merge options

    html_options = {:class => 'ui search selection dropdown'}.merge html_options

    select method, Platform.order(:name => :asc).collect { |p| [p.name, p.id] }, options, html_options
  end
end
