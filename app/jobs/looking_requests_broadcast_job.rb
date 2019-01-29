class LookingRequestsBroadcastJob < ApplicationJob
  include Rails.application.routes.url_helpers

  queue_as :default

  def perform(request, status)
    if status.to_s == 'destroy'
      content = {
        :content => request.id,
        :status => :destroy,
        :extra => request.id
      }
    else
      content = {
        :content => render_request(request),
        :status => :save,
        :extra => request.id
      }
    end

    LookingRequestsChannel.broadcast_to LookingRequest, content
  end

  protected

    def render_request(request)
      ApplicationController.renderer.render(
        :partial => '/web/looking_requests/shared/item',
        :locals => { :looking_request => request }
      )
    end
end
