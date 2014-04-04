MobileApp::Application.routes.draw do
  resources :museums , path: 'api/museums' do
  	collection { post :import }
  end

  post 'api/checkin', defaults: {format: :json},  to: 'checkin#create', as: :checkin
  get 'api/checkin', defaults: {format: :json},  to: 'checkin#show', as: :get_checkin

end
