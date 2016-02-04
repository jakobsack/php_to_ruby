Rails.application.routes.draw do
  resources :repositories do
    member do
      post :fetch
      get :diff
    end
  end
  root 'repositories#index'
end
