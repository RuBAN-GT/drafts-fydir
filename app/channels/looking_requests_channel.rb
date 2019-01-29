class LookingRequestsChannel < ApplicationCable::Channel
  def subscribed
    stream_for LookingRequest
  end

  def unsubscribed
    stop_all_streams
  end
end
