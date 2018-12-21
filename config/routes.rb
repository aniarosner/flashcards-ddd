Rails.application.routes.draw do
  resources :courses, only: %i[index create destroy] do
    resources :decks, only: %i[index create]
  end

  resources :decks, only: [] do
    get :cards, on: :member
    resources :cards, only: %i[create]
  end
end
