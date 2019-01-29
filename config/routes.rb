Rails.application.routes.draw do
  # admin
  mount RailsAdmin::Engine => '/adminka', as: 'rails_admin'

  default_routes = Proc.new { |scope|
    # devise settings
    devise_for :users, :path => :account, :controllers => {
      :confirmations => "#{scope}/devise/confirmations",
      # :omniauth_callbacks => "#{scope}/devise/omniauth_callbacks",
      :passwords => "#{scope}/devise/passwords",
      :registrations => "#{scope}/devise/registrations",
      :sessions => "#{scope}/devise/sessions",
      :unlocks => "#{scope}/devise/unlocks"
    }

    except = [:destroy, :new, :create]
    except = except + [:edit] unless scope == :web

    # users namespace
    resources :users, :param => :nickname, :except => except do
      # guardian operations
      get  :guardian_verification, :action => :guardian_verification
      patch :guardian_verification, :action => :guardian_verification_check

      # guardain data
      get :guardian, :action => :guardian unless scope == :web
      patch :guardian, :action => :guardian_reload

      # ratio operations
      unless scope == :web
        get 'ratio' => 'user_ratios#index', :as => :ratio
        post 'ratio' => 'user_ratios#create'
        delete 'ratio' => 'user_ratios#destroy'
      end
    end

    except = (scope == :web) ? [] : [:new, :edit]
    # looking requests
    resources :looking_requests, :path => :lfg, :except => except
  }

  scope :module => :web, :is_api => false, :my_namespace => :web do
    # home page
    root 'pages#index'

    # other
    default_routes.call :web

    # any conversation redirects
    resources :conversations, :only => [:index, :create]
  end

  namespace :api, :is_api => true, :my_namespace => :api, :defaults => {:format => :json} do
    namespace :v1, :my_namespace => 'api/v1', :constraints => ApiVersion.new(1) do
      default_routes.call 'api/v1'

      root 'looking_requests#index'

      # conversations
      resources :conversations, :only => [:index, :show, :create, :destroy] do
        resources :messages, :only => [:index, :show, :create]
      end

      match '*path' => 'pages#error_404', :via => :all unless Rails.env.development?
    end
  end

  namespace :widgets, :is_api => false, :my_namespace => :widgets do
    # conversations
    resources :conversations, :only => [:index, :show, :create, :destroy] do
      resources :messages, :only => [:index, :show, :create]
    end

    match '*path' => 'conversations#index', :via => :all unless Rails.env.development?
  end

  match '*path' => 'web/pages#error_404', :via => :all unless Rails.env.development?
end
