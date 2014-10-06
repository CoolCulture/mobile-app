MobileApp::Application.routes.draw do
  scope "/api", defaults: {format: :json} do
    resources :museums do
      collection { post :import }
    end

    resources :family_cards do
      collection { post :import }
    end

    resources :checkins, only: [:show, :create, :index]
  end
end
