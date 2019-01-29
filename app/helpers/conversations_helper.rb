module ConversationsHelper
  # Get lable with unread conversations
  def unread_label
    count = current_user.unseen_count
    class_name = count > 0 ? 'red' : 'default'

    "<span title='#{t 'tips.conversations.unread'}' tooltip='true' class='ui #{class_name} tiny unread circular label'>#{count}</span>".html_safe
  end

  # Get full message
  def full_message(options = {})
    content_tag :div, :class => "full #{options[:class]} message" do
      content_tag :div, :class => :content do
        content_tag :div, :class => :center do
          content_tag :div, :class => 'ui icon header' do
            icon(:smile) +
            content_tag(:div, :class => :text) do
              block_given? ? yield : options[:body]
            end
          end
        end
      end
    end
  end
end
