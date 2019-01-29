module LookingActivitiesHelper
  def looking_activity_label(activity)
    if activity.nil?
      name = t 'looking_activities.template.every'
      link = looking_requests_path(:looking_activity => nil)
    else
      name = activity.name
      link = looking_requests_path(:looking_activity => activity.slug)
    end

    link_to "#{icon :star} #{name}".html_safe, link, :class => 'ui activity teal label'
  end

  def looking_activity_link(activity)
    if activity.nil?
      name = t 'template.looking_activities.every'
      link = looking_requests_path(:looking_activity => nil)
    else
      name = activity.name
      link = looking_requests_path(:looking_activity => activity.slug)
    end

    link_to name, link, :class => 'activity'
  end

  def looking_activity_tag(method = :looking_activity, html_options = {})
    html_options = {
      :id => :id,
      :class => 'search',
      :icon => :star,
      :include_blank => t('template.looking_activities.all')
    }.merge html_options

    semantic_select method,
      LookingActivity.order(html_options[:id] => :asc),
      html_options
  end
end

class ActionView::Helpers::FormBuilder
  def looking_activity(method, options = {}, html_options = {})
    options = {
      :include_blank => I18n.t('template.looking_activities.all'),
      :selected => (object && object.looking_activity && object.looking_activity.id)
    }.merge options

    html_options = {:class => 'ui search selection dropdown'}.merge html_options

    select method, LookingActivity.order(:slug => :asc).collect { |p| [p.name, p.id] }, options, html_options
  end
end
