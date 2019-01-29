class Api::V1::UserRatiosController < Api::V1::ApplicationController
  acts_as_token_authentication_handler_for User, :except => [:index]
  before_action :authenticate_user!, :except => [:index]
  before_action :set_user

  def index
    @user_ratio = @user.ratio
  end

  def create
    data = params.require(:user_ratio).permit(:point)

    if data[:point] == nil || data[:point].to_s == '0'
      destroy
    else
      r = UserRatio.where(:voted_id => current_user.id, :user_id => @user.id).first_or_initialize
      r.point = data[:point]

      unless r.save
        api_response.error_code = 22

        add_flash_message 'Ошибка валидации', :error
      end
    end
  end

  def destroy
    UserRatio.where(:user_id => @user.id, :voted_id => current_user.id)&.first&.destroy
  end

  protected

    def set_user
      @user = User.find_by_nickname(params[:nickname] || params[:user_nickname])

      raise ActiveRecord::RecordNotFound if @user.nil?
    end
end
