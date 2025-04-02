Rails.application.routes.draw do
  root 'posts#index'
  resources :posts do
    resources :comments, only: [:create, :destroy]
  end
  get "up" => "rails/health#show", as: :rails_health_check
end
