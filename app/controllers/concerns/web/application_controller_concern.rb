module Web::ApplicationControllerConcern
  extend ActiveSupport::Concern

  included do
    before_action :default_meta_tags

    layout '/web/layouts/application'

    before_action :devise_sub_layout
    helper_method :sub_layout
  end

  # Set & get sub layout
  #
  # @param [String] name
  # @return [String]
  def sub_layout(name = nil)
    @sub_layout = name.to_s unless name.blank?

    @sub_layout
  end

  def add_flash_message(message, type = :notice)
    type = type.to_sym

    if flash.now[type].is_a? String
      flash.now[type] = [flash[type]]
    else
      flash.now[type] ||= []
    end

    flash.now[type] << message
  end

  protected
    # Change devise sub layout
    def devise_sub_layout
      if devise_controller?
        (user_signed_in?) ? sub_layout(:user_settings) : sub_layout(:devise_guest)
      end
    end

    def handle_error_400
      render "/web/pages/error_400", :status => 400
    end

    def handle_error_404
      render "/web/pages/error_404", :status => 404
    end
end
