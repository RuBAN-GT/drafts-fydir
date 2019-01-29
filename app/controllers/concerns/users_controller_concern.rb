module UsersControllerConcern
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user!, :only => [:edit, :update, :guardian_verification_check, :guardian_verification, :guardian_reload]

    acts_as_token_authentication_handler_for User, :only => [:edit, :update, :guardian_verification_check, :guardian_verification, :guardian_reload]

    before_action :set_user, :only => [:show, :edit, :update, :guardian_verification_check, :guardian_verification, :guardian_reload, :guardian]

    before_action :current_user_only!, :only => [:edit, :update, :guardian_verification_check, :guardian_verification, :guardian_reload]
  end

  def index
    @users = User.filter(params.slice(:nickname, :platform, :guardian_name)).paginate(:page => params[:page], :per_page => 10)
  end

  def show
  end

  def edit
  end

  def update
  end

  def guardian_verification
  end

  def guardian_verification_check
    @user.guardian_verify
  end

  def guardain
  end

  def guardian_reload
    @user.guardian_update
  end

  protected

    def set_user
      @user = User.find_by_nickname(params[:nickname] || params[:user_nickname])
    end

    def user_params
      params.require(:user).permit(:realname, :about,  :current_password, :platform_id, :guardian_name, :vkontakte, :facebook, :twitter, :twitch, :telegram)
    end
end
