class Api::V1::Devise::PasswordsController < Devise::PasswordsController
  include Api::ApplicationControllerConcern

  def create
    self.resource = resource_class.send_reset_password_instructions(resource_params)
    yield resource if block_given?

    if user_signed_in?
      api_response.error_code = 14
    elsif !successfully_sent? resource
      api_response.error_code = 15
    end
  end

  def update
    self.resource = resource_class.reset_password_by_token(resource_params)

    yield resource if block_given?

    if resource.errors.empty?
      resource.unlock_access! if unlockable?(resource)

      sign_in(resource_name, resource) if Devise.sign_in_after_reset_password
    else
      api_response.error_code = 22

      set_minimum_password_length
    end
  end
end
