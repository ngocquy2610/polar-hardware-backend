Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  namespace "api" do
    namespace "v1" do
      get "pings", to: "pings#index" # api/v1/pings
      get "products", to: "products#index"
    end
  end
end
