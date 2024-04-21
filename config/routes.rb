Rails.application.routes.draw do
  root "posts#index"

  resources :questions do
    resources :answers
  end
end
