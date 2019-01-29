class Api::V1::ConversationsController < Api::V1::ApplicationController
  include ConversationsControllerConcern

  def create
    super

    render :show
  end
end
