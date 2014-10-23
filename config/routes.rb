MobileApp::Application.routes.draw do
  scope "/api" do
    devise_for :users, defaults: { format: :json }

    resources :museums do
      collection { post :import }
      resources :activities, controller: 'one_time_activities'
      resources :one_time_activities
    end

    resources :family_cards do
      collection { post :import }
    end

    resources :checkins, only: [:show, :create, :index]
  end
end
