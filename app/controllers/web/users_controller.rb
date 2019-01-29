class Web::UsersController < Web::ApplicationController
  include UsersControllerConcern

  before_action :set_sub_layout, :only => [:edit, :update, :guardian_verification_check, :guardian_verification_unlink, :guardian_verification]

  def update
    if @user.update user_params
      add_flash_message t('flash.users.updated'), :success
    else
      add_flash_message t('flash.users.profile_error'), :error
    end

    render :edit
  end

  def guardian_verification
    redirect_to edit_user_path(@user, anchor: 'game'), :flash => {:warning => t('flash.users.before_action')} unless @user.guardian_name.present?
  end

  def guardian_verification_check
    super

    if @user.guardian_verified?
      add_flash_message t('flash.users.verify_success'), :success
    else
      add_flash_message t('flash.users.verify_wrong'), :error
    end

    render :guardian_verification
  end

  def guardian_reload
    if @user.allow_update_guardian?
      @user.guardian_update!

      redirect_to user_path(current_user, :anchor => 'statistics'), :flash => {:success => t('flash.users.updated')}
    else
      redirect_to user_path(current_user, :anchor => 'statistics'), :flash => {:error => t('flash.users.update_limit')}
    end
  end

  protected

    def set_sub_layout
      sub_layout :user_settings
    end
end
