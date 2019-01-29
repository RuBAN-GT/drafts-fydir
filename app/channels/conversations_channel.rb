class ConversationsChannel < ApplicationCable::Channel
  def subscribed
    if current_user.nil?
      reject_subscription
    else
      stream_for current_user
    end
  end

  def unsubscribed
    stop_all_streams
  end
end
