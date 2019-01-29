module LookingRequestsControllerConcern
  extend ActiveSupport::Concern

  included do
    acts_as_token_authentication_handler_for User, :only => [:new, :create, :edit, :update, :destroy]

    before_action :authenticate_user!, :only => [:new, :create, :edit, :update, :destroy]

    before_action :set_looking_request, :only => [:show, :edit, :update, :destroy]

    before_action :owner_only!, :only => [:edit, :update, :destroy]
  end

  def index
    @looking_requests = LookingRequest.filter(params.slice(
      :looking_activity,
      :platform,
      :microphone,
      :looking_type,
      :min_light,
      :experience,
      :user
    )).paginate(:page => params[:page])
  end

  def show
  end

  def new
    @looking_request = LookingRequest.new

    @looking_request.user_id  = current_user
    @looking_request.platform = current_user.platform
  end

  def create
    @looking_request = LookingRequest.new(looking_request_params)

    @looking_request.save
  end

  def edit
  end

  def update
    @looking_request.update looking_request_params
  end

  def destroy
    @looking_request.destroy
  end

  protected

    def set_looking_request
      @looking_request = LookingRequest.find(params[:id] || params[:looking_request_id])
    end

    def looking_request_params
      data = params.require(:looking_request).permit(:description, :platform_id, :looking_type, :microphone, :looking_activity_id, :min_light, :experience)

      data[:user_id] = current_user.id

      data
    end

    def owner_only!
      current_user_only! @looking_request.user.nickname
    end
end
