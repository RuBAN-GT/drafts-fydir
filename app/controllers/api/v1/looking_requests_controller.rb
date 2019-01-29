class Api::V1::LookingRequestsController < Api::V1::ApplicationController
  include LookingRequestsControllerConcern

  def create
    super

    if @looking_request.new_record?
      api_response.error_code = 22

      add_flash_message t('flash.looking_requests.wrong'), :error
    else
      add_flash_message t('flash.looking_requests.created'), :success
    end

    render :show
  end

  def update
    if @looking_request.update looking_request_params
      add_flash_message t('flash.looking_requests.updated'), :success
    else
      api_response.error_code = 22

      add_flash_message t('flash.looking_requests.wrong'), :error
    end

    render :show
  end
end
