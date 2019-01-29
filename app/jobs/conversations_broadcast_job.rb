class ConversationsBroadcastJob < ApplicationJob
  queue_as :default

  def perform(conversation, status, user = nil)
    hash = conversation.export_hash

    hash[:status] = status
    hash[:type]   = 'conversation'

    if user.nil?
      conversation.conversation_members.each do |member|
        next unless conversation.has_active_user? member.user

        hash[:unseen_count] = member.user.unseen_count

        ConversationsChannel.broadcast_to member.user, hash
      end
    elsif status == 'destroy' || conversation.has_active_user?(user)
      hash[:unseen_count] = user.unseen_count

      ConversationsChannel.broadcast_to user, hash
    end
  end
end
