class Api::V1::Devise::SessionsController < Devise::SessionsController
  include Api::ApplicationControllerConcern

  skip_before_filter :verify_signed_out_user, :only => :destroy

  def create
    self.resource = warden.user

    if self.resource.nil?
      data = params.require(:user).permit(:email, :password)

      self.resource = User.find_by_email data[:email] unless data[:email].nil?

      if !data.nil? && !self.resource.nil? && self.resource.valid_password?(data[:password])
        sign_in :user, self.resource
        yield resource if block_given?
      else
        self.resource = nil

        warden.custom_failure!

        api_response.error_code = 401
      end
    else
      sign_in :user, self.resource
      yield resource if block_given?
    end

    render '/api/v1/devise/sessions/create', :status => (self.resource.nil? ? 401 : 200)
  end

  def destroy
    Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)

    yield if block_given?
  end
end
