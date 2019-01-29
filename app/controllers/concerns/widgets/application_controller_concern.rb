module Widgets::ApplicationControllerConcern
  extend ActiveSupport::Concern

  included do
    before_action :default_meta_tags

    acts_as_token_authentication_handler_for User

    before_action :authenticate_user!
  end

  protected

    def handle_error_400
      redirect_to widgets_conversations_path
    end

    def handle_error_404
      redirect_to widgets_conversations_path
    end
end
