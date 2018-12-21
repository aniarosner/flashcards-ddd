Rails.application.routes.draw do
  root 'courses#index'

  resources :courses, only: %i[index create destroy], param: :uuid do
    resources :decks, only: %i[index create destroy], param: :uuid
  end

  resources :decks, only: [], param: :uuid do
    get :cards, on: :member
    post :add_card, on: :member
    delete :remove_card, on: :member
  end
end
