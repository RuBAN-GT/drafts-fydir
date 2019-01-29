class Web::Devise::RegistrationsController < Devise::RegistrationsController
  include Web::ApplicationControllerConcern
  
  protected

    def sign_up_params
      params.require(:user).permit(:email, :password, :password_confirmation, :nickname, :realname, :guardian_name, :platform_id)
    end

    def after_update_path_for(resource)
      edit_user_registration_path
    end
end
