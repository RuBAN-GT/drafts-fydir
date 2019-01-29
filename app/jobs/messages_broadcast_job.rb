class MessagesBroadcastJob < ApplicationJob
  include Rails.application.routes.url_helpers

  queue_as :default

  def perform(message)
    MessagesChannel.broadcast_to message.conversation,
      message.export_hash
  end
end
