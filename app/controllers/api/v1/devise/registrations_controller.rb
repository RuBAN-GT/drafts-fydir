class Api::V1::Devise::RegistrationsController < Devise::RegistrationsController
  include Api::ApplicationControllerConcern

  def create
    build_resource sign_up_params

    resource.save

    yield resource if block_given?

    if resource.persisted?
      resource.active_for_authentication? ? sign_up(resource_name, resource) : expire_data_after_sign_in!
    else
      api_response.error_code = 22

      clean_up_passwords resource

      set_minimum_password_length
    end
  end

  def update
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)

    resource_updated = update_resource(resource, account_update_params)

    yield resource if block_given?

    if resource_updated
      bypass_sign_in resource, scope: resource_name
    else
      api_response.error_code = 22

      clean_up_passwords resource
    end
  end

  def destroy
    resource.destroy

    Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)

    yield resource if block_given?
  end
  
  protected

    def sign_up_params
      params.require(:user).permit(:email, :password, :password_confirmation, :nickname, :realname, :guardian_name, :platform_id)
    end
end
