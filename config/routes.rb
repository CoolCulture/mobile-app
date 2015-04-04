MobileApp::Application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  scope "/api" do
    devise_for :users, defaults: { format: :json }

    resources :users, only: [:create]

    resources :museums, only: [:index, :show]

    resources :family_cards, only: [:show]

    resources :checkins, only: [:show, :create]

    get '/activities/upcoming', to: 'activities#upcoming'
  end
end
