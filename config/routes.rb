MobileApp::Application.routes.draw do
  scope "/api" do
    devise_for :users, defaults: { format: :json }

    resources :users, only: [:create]

    resources :museums, only: [:index, :show]

    resources :family_cards, only: [:show]

    resources :checkins, only: [:show, :create]

    get '/activities/upcoming', to: 'activities#upcoming'
    get '/activities/featured', to: 'activities#featured'
  end

  namespace :admin do
    resources :museums do
      collection { post :import }
      resources :activities, controller: 'one_time_activities'
      resources :one_time_activities
      resources :recurring_activities, except: [:index, :show]
    end

    resources :users do
      collection { post :import }
      member { post :reset_password }
    end

    resources :family_cards do
      collection { post :import }
    end

    resources :checkins, only: [:show, :create, :index]
  end
end
