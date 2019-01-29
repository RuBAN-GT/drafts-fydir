class ConversationsClearJob < ApplicationJob
  queue_as :default

  def perform(*args)
    Conversation.destroy_empty
  end
end
