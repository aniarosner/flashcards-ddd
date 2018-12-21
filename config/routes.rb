Rails.application.routes.draw do
  root 'courses#index'

  resources :courses, only: %i[index create destroy] do
    resources :decks, only: %i[index create destroy]
  end

  resources :decks, only: [] do
    get :cards, on: :member
    post :add_card, on: :member
    delete :remove_card, on: :member
  end
end
