Rails.application.routes.draw do
  resources :courses, only: %i[index create destroy] do
    resources :decks, only: %i[index create]
  end
end
