class Web::Devise::SessionsController < Devise::SessionsController
  include Web::ApplicationControllerConcern

  def destroy
    Rails.cache.delete "online.#{current_user.id}"

    super
  end
end
