class Web::PagesController < Web::ApplicationController
  def index
    render '/web/pages/index', :layout => false
  end

  def error_400
    render '/web/pages/error_400.html.erb', :status => 400
  end

  def error_404
    render '/web/pages/error_404.html.erb', :status => 404
  end
end
