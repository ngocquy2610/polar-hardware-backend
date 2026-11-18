Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  namespace "api" do
    namespace "v1" do
      get "pings", to: "pings#index" # api/v1/pings
      resources :products, only: [:index, :show, :create, :update, :destroy]
    end
  end
end
