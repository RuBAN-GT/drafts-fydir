module ConversationsControllerConcern
  extend ActiveSupport::Concern

  included do
    acts_as_token_authentication_handler_for User

    before_action :authenticate_user!

    before_action :set_conversation, only: [:show, :destroy]
    before_action :member_only!, only: [:show, :destroy]
  end

  def index
    @conversations = Conversation.actual.joins(:conversation_members).where(
      'conversation_members.user_id' => current_user.id,
      'conversation_members.parted' => true
    ).joins(:messages).distinct.paginate(:page => params[:page])
  end

  def show
  end

  def create
    @conversation = Conversation.new

    data = conversation_params
    data[:users].delete current_user.nickname

    if data[:users].any?
      correct = data[:users].all? { |nickname|
        !User.find_by_nickname(nickname).nil?
      }

      if correct
        user = User.find_by_nickname(data[:users].first)

        data[:users] = [current_user, user]

        @conversation = Conversation.strong_contain(*data[:users])

        if @conversation.nil?
          @conversation = Conversation.new()

          @conversation.join *data[:users]

          @conversation.save
        end
      end
    end

    @conversation.conversation_members.where(
      'conversation_members.parted' => false,
      'conversation_members.user_id' => data[:users].map { |u|
        u.id
      }
    ).update_all(:parted => true) if @conversation.persisted?
  end

  def destroy
    @conversation.leave current_user
  end

  protected

    def conversation_params
      params.require(:conversation).permit(:users => [])
    end

    def set_conversation
      @conversation = Conversation.find(params[:id])
    end

    def member_only!
      raise ActiveRecord::RecordNotFound unless @conversation.has_user? current_user
    end
end
