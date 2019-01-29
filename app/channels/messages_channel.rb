class MessagesChannel < ApplicationCable::Channel
  def subscribed
    reject_subscription if current_user.nil?
  end

  def follow(options)
    stop_all_streams

    if options.is_a?(Hash) && !options['conversation'].nil?
      conversation = Conversation.find(options['conversation']) rescue nil

      stream_for conversation unless conversation.nil? || !conversation.has_user?(current_user)
    end
  end

  def unsubscribed
    stop_all_streams
  end
  alias_method :unfollow, :unsubscribed
end
