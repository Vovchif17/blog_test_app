Rails.application.routes.draw do
  resource :session
  delete "/session", to: "sessions#destroy"
  resources :passwords, param: :token
  root 'posts#index'
  resources :posts do
    resources :comments, only: [:create, :destroy]
  end
  get "up" => "rails/health#show", as: :rails_health_check
end
