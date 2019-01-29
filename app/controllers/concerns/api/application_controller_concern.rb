module Api::ApplicationControllerConcern
  extend ActiveSupport::Concern

  included do
    protect_from_forgery with: :null_session

    # skip_before_filter :verify_authenticity_token
    after_filter :set_csrf_header, only: [:new, :create]

    before_action :api_response
    helper_method :api_response

    respond_to :json
  end

  def api_response
    return @api_response unless @api_response.nil?

    @api_response = ApiResponse.new
  end

  protected

    def set_csrf_header
      response.headers['X-CSRF-Token'] = form_authenticity_token
    end

    def handle_all_flash
      super

      handle_validation_messages
      handle_api_response_flash
    end

    def handle_validation_messages
      if devise_controller?
        object = self.resource
      else
        object = instance_variable_get "@#{controller_name.classify.underscore}"
      end

      logger.info "@#{controller_name.classify.underscore}"

      object.errors.keys.each do |key|
        flash["error.validation.#{key}"] = object.errors.full_messages_for(key)
      end if !object.nil? && object.respond_to?(:errors) && object.errors.any?
    end

    def handle_api_response_flash
      flash.each do |status, messages|
        api_response.message status, messages
      end
    end

    def handle_error_400
      api_response.error_code = 400

      render "api/v1/pages/error_400", :status => 400
    end
    def handle_error_404
      api_response.error_code = 404

      render "api/v1/pages/error_404", :status => 404
    end
end
