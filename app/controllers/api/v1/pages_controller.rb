class Api::V1::PagesController < Api::V1::ApplicationController
  def error_400
    api_response.error_code = 400

    render '/api/v1/pages/error_400', :status => 400
  end

  def error_404
    api_response.error_code = 404

    render '/api/v1/pages/error_404', :status => 404
  end
end
