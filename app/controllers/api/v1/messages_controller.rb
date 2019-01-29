class Api::V1::MessagesController < Api::V1::ApplicationController
  include MessagesControllerConcern

  def create
    super

    render :show
  end
end
