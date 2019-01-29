class Web::ConversationsController < Web::ApplicationController
  include ConversationsControllerConcern

  def index
    respond_to do |format|
      format.html { redirect_to widgets_conversations_path }
      format.js {}
    end
  end

  def create
    super

    respond_to do |format|
      format.html {
        if @conversation.persisted?
          redirect_to widgets_conversation_messages_path(@conversation)
        else
          redirect_to widgets_conversations_path
        end
      }
      format.js {}
    end
  end
end
