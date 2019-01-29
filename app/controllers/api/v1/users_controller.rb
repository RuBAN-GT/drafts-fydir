class Api::V1::UsersController < Api::V1::ApplicationController
  include UsersControllerConcern

  def create
    super

    render :show
  end

  def update
    if @user.update user_params
      add_flash_message t('flash.users.updated'), :success
    else
      api_response.error_code = 22

      add_flash_message t('flash.users.profile_error'), :error
    end

    render :show
  end

  def guardian_verification
    unless @user.guardian_name.present?
      api_response.error_code = 409

      add_flash_message t('flash.users.before_action'), :error
    end
  end

  def guardian_verification_check
    super

    if @user.guardian_verified?
      add_flash_message t('flash.users.verify_success'), :success
    else
      api_response.error_code = 401

      add_flash_message t('flash.users.verify_wrong'), :error
    end

    render :guardian_verification
  end

  def guardian_reload
    super

    render :guardian
  end
end
