Rails.application.routes.draw do
  root 'courses#index'
  mount RailsEventStore::Browser => '/res' if Rails.env.development?

  resources :courses, only: %i[index create new destroy], param: :uuid do
    resources :decks, only: %i[index create new destroy], param: :deck_uuid do
      get :cards, on: :member
      post :add_card, on: :member
      get :new_card, on: :member
      delete :remove_card, on: :member
    end
  end
end
