Rails.application.routes.draw do
  resources :courses, only: %i[index create destroy]
end
