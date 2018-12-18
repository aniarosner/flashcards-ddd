Rails.application.routes.draw do
  resources :courses, only: [:index, :create]
end
