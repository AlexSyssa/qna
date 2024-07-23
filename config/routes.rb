Rails.application.routes.draw do
  devise_for :users

  resources :questions do
    resources :answers, shallow: true, except: %i[ index ] do
      patch :mark_as_best, on: :member
    end
  end

  root to: "questions#index"
end