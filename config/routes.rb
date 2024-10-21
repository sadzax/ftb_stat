Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :statistics, only: [:create]
      get 'rankings', to: 'rankings#index'
    end
  end
end
