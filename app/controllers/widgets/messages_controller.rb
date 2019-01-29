class Widgets::MessagesController < Widgets::ApplicationController
  include MessagesControllerConcern

  layout '/widgets/layouts/conversations'

  def create
    super

    respond_to do |format|
      format.html {
        redirect_to widgets_conversation_messages_path(@conversation)
      }
      format.js {}
    end
  end

  def show
    super

    respond_to do |format|
      format.html {
        redirect_to widgets_conversation_messages_path(@conversation)
      }
      format.js {}
    end
  end

  protected

    def member_only!
      redirect_to widgets_conversations_path unless @conversation.has_user? current_user
    end
end
