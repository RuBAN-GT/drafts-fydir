module LookingRequestsHelper
  # Get microphone require label
  def microphone_label(t)
    text = t("params.looking_requests.microphone.types.#{t ? 'require' : 'not_require'}")

    content_tag :div,
      "#{icon (t ? "microphone" : "microphone slash")} #{text}".html_safe,
      :class => "ui grey microphone label"
  end

  # Show labels with minimum light of the request
  def min_light_label(light)
    content_tag :div,
      :class => "ui horizontal basic orange light label",
      :title => t('tips.looking_requests.min_light'),
      :tooltip => true do
      icon(:light) +
      content_tag(:span, light)
    end unless light.nil?
  end

  # Show label with exp state
  def experience_label(type)
    content_tag :div,
      :class => "ui horizontal basic blue experience label",
      :title => t('tips.looking_requests.experience'),
      :tooltip => true do
      icon(:certificate) +
      content_tag(:span, LookingRequest.experience_name(type))
    end
  end

  # Get selector with experience fields
  def experience_tag(method = :experience, html_options = {})
    html_options = {
      :icon => :certificate,
      :include_blank => t('params.looking_requests.experience.placeholder'),
      :option_blank => t('params.looking_requests.experience.types.every')
    }.merge html_options

    semantic_select method,
      [
        {
          :name => t('params.looking_requests.experience.types.novice'),
          :id => 'novice'
        },
        {
          :name => t('params.looking_requests.experience.types.sherpa'),
          :id => 'sherpa'
        }
      ],
      html_options
  end

  # Get selector with looking types
  def looking_type_tag(method = :looking_type, html_options = {})
    html_options = {
      :icon => :users,
      :include_blank => t('activerecord.attributes.looking_request.looking_type'),
      :option_blank => t('params.looking_requests.looking_type.types.all')
    }.merge html_options

    semantic_select method,
      [
        {
          :name => t('params.looking_requests.looking_type.types.group'),
          :id => 'group'
        },
        {
          :name => t('params.looking_requests.looking_type.types.member'),
          :id => 'member'
        }
      ],
      html_options
  end
end

class ActionView::Helpers::FormBuilder
  def looking_type(method, options = {}, html_options = {})
    options = {
      :selected => (object && object.looking_type)
    }.merge options

    html_options = {:class => 'ui selection dropdown'}.merge html_options

    select method,
      [
        [
          I18n.t('params.looking_requests.looking_type.search.group'),
          'group'
        ],
        [
          I18n.t('params.looking_requests.looking_type.search.member'),
          'member'
        ]
      ],
      options,
      html_options
  end

  def experience(method, options = {}, html_options = {})
    options = {
      :selected => (object && object.experience)
    }.merge options

    html_options = {:class => 'ui selection dropdown'}.merge html_options

    select method, [
      [I18n.t('params.looking_requests.experience.types.every'), 'every'],
      [I18n.t('params.looking_requests.experience.types.novice'), 'novice'],
      [I18n.t('params.looking_requests.experience.types.sherpa'), 'sherpa']
    ], options, html_options
  end
end
