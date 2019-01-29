module MessagesControllerConcern
  extend ActiveSupport::Concern

  included do
    acts_as_token_authentication_handler_for User

    before_action :authenticate_user!

    before_action :set_conversation
    before_action :member_only!

    before_action :join, :only => [:index, :show]
    before_action :view, :only => [:index, :show]
  end

  def index
    @messages = @conversation.messages.paginate(:page => params[:page])

    @message = Message.new
  end

  def create
    @message = Message.new({
      :user_id => current_user.id,
      :conversation_id => params[:conversation_id]
    }.merge(message_params))

    @message.save
  end

  def show
    @message = Message.find(params[:id])
  end

  protected

    def message_params
      params.require(:message).permit(:body)
    end

    def set_conversation
      @conversation = Conversation.find(params[:conversation_id])
    end

    def member_only!
      raise ActiveRecord::RecordNotFound unless @conversation.has_user? current_user
    end

    def join
      unless @conversation.has_active_user? current_user
        @conversation.join current_user
      end
    end
    def view
      unless @conversation.seen? current_user
        @conversation.view current_user
      end
    end
end
