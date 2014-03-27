MobileApp::Application.routes.draw do
  resources :museums , path: 'api/museums' do
  	collection { post :import }
  end
end
