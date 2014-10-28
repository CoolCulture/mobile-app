MobileApp::Application.routes.draw do
  scope "/api" do
    devise_for :users, defaults: { format: :json }
    
    resources :museums, only: [:index, :show]

    resources :family_cards, only: [:show]

    resources :checkins, only: [:show, :create]
  end

  namespace :admin do
    resources :museums do
      collection { post :import }
      resources :activities, controller: 'one_time_activities'
      resources :one_time_activities
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
