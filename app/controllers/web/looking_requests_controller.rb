class Web::LookingRequestsController < Web::ApplicationController
  include LookingRequestsControllerConcern

  def show
    super

    set_meta_tags :title => @looking_request.title

    respond_to do |format|
      format.html {
        index

        render :action => :index, :locals => { :modal => :show }
      }
      format.js {}
    end
  end

  def new
    super

    set_meta_tags :title => t('meta_tags.looking_requests.new.title')

    respond_to do |format|
      format.html {
        index

        render :action => :index, :locals => { :modal => :new }
      }
      format.js {}
    end
  end

  def create
    super

    if @looking_request.persisted?
      redirect_to @looking_request, :flash => { :success => t('flash.looking_requests.created') }
    else
      index

      set_meta_tags :title => t('meta_tags.looking_requests.new.title')

      add_flash_message t('flash.looking_requests.wrong'), :error

      render :action => :index, :locals => { :modal => :new }
    end
  end

  def edit
    super

    set_meta_tags :title => t('meta_tags.looking_requests.edit.title')

    respond_to do |format|
      format.html {
        index

        render :action => :index, :locals => { :modal => :edit }
      }
      format.js {}
    end
  end

  def update
    if @looking_request.update looking_request_params
      redirect_to @looking_request, :flash => { :success => t('flash.looking_requests.updated') }
    else
      index

      set_meta_tags :title => t('meta_tags.looking_requests.edit.title')

      add_flash_message t('flash.looking_requests.wrong'), :error

      render :action => :index, :locals => { :modal => :edit }
    end
  end

  def destroy
    super

    respond_to do |format|
      format.html {
        redirect_to looking_requests_path, :flash => { :success => t('flash.looking_requests.destroyed') }
      }
      format.js {}
    end
  end
end
