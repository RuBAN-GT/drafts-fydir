module UsersHelper
  # get pin of user online status
  def online_label(user)
    online = user.online?

    content_tag :div, nil,
      :class => "ui #{online ? "green" : "grey"} empty circular online label",
      :tooltip => true,
      :title => t("tips.users.online.#{online ? 'online' : 'offline'}")
  end

  # get user ratio bar
  def user_ratio(user, options = {})
    content_tag :div, nil, :class => "ui #{options[:class]} star user rating", :data => {
      :user => user.nickname,
      :rating => user.ratio,
      'max-rating' => '5'
    }
  end
  def user_voted_ratio(user, options = {})
    content_tag :div, nil, :class => "ui #{options[:class]} star voted rating",
      :title => t('tips.users.vote'),
      :tooltip => true,
      :data => {
        :link => api_v1_user_ratio_path(@user),
        :user => user.nickname,
        :rating => user.voted_ratio(current_user),
        'max-rating' => '5'
      } if user_signed_in? && current_user != user
  end

  # get user guardian name in label
  def guardian_label(user)
    link_to "#{icon :user} #{user.guardian_name}".html_safe,
      user.guardian_url,
      :class => "ui #{'orange' if user.guardian_verified?} guardian name label",
      :title => (user.guardian_verified? ? t('tips.users.verification.verified') : t('tips.users.verification.unverified')),
      :tooltip => true,
      :target => :_blank if user.guardian_name.present?
  end

  # get guardian link
  def guardian_link(user)
    link_to icon("#{user.guardian_verified? ? 'orange' : ''} game"),
      user.guardian_url,
      :class => 'contact guardian',
      :title => user.guardian_name,
      :tooltip => true,
      :target => :_blank if user.guardian_name.present?
  end

  # get user lable
  def user_label(user)
    status = (user.guardian_verified?) ? "orange" : "default"

    content_tag :div, :class => "ui user #{status} link image label" do
      link_to(user_path(user), :class => :basic, :tooltip => true, :title => t('tips.users.show_profile')) do
        image_tag(user.avatar) +
        user.nickname
      end +
      start_conversation_link(user, :class => :detail, :icon => :mail)
    end
  end
  def user_mini_label(user)
    status = (user.guardian_verified?) ? "orange" : "default"

    content_tag :div, :class => "ui user #{status} link image label" do
      link_to(user_path(user), :class => :basic, :tooltip => true, :title => t('tips.users.show_profile')) do
        image_tag(user.avatar) +
        user.nickname
      end
    end
  end

  # get guardian maximum light
  def guardian_light(user)
    return if user.guardian.nil?

    light = user.guardian.get_historical_stats_for_account&.mergedAllCharacters&.merged&.allTime&.highestLightLevel&.basic&.displayValue

    content_tag :div,
      "#{icon :light} #{light}".html_safe,
      :title => t('tips.users.light'),
      :tooltip => true,
      :class => "ui guardian light basic horizontal label" unless light.nil?
  end

  # link for string conversation
  def start_conversation_link(user, options = {})
    link_to icon(options[:icon] ||'mail outline'),
      conversations_path(:conversation => {:users => [user.nickname]}),
      :method => :post,
      :remote => true,
      :class => "ui link start #{options[:class]} conversation",
      :title => t('tips.users.send_message'),
      :tooltip => true if user_signed_in? && !is_current?(user)
  end

  # show contact button
  def contact_link(user, contact, options = {})
    options = {:icon => contact.to_s}.merge options

    link_to icon(options[:icon]),
      user.send(contact),
      :class => "#{contact} contact",
      :title => t("activerecord.attributes.user.#{contact}"),
      :tooltip => true,
      :target => :_blank if user.has_attribute?(contact) && user.send(contact).present?
  end

  # get user input with searchable helpers
  def user_field_tag(method, value = nil, html_options = {})
    html_options = {
      'data-search' => method,
      :placeholder  => t("activerecord.attributes.user.#{method}"),
      :class => 'ui users search',
      :icon => :user
    }.merge html_options

    content_tag :div, {
      :class => html_options[:class],
      'data-search' => html_options['data-search']
    } do
      output = ''

      if html_options[:icon].nil?
        output = text_field_tag(method, value, :placeholder => html_options[:placeholder], :class => :prompt)
      else
        output = content_tag :div, :class => 'ui left icon input' do
          text_field_tag(method, value, :placeholder => html_options[:placeholder], :class => :prompt) +
          icon(html_options[:icon])
        end
      end

      output + content_tag(:div, nil, :class => :results)
    end
  end
end
