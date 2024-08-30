# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users

  resources :attachments, only: :destroy
  resources :links, only: :destroy
  resources :awards, only: :index

  concern :voted do
    member do
      patch :upvote
      patch :downvote
      delete :cancel
    end
  end

  resources :questions, concerns: :voted do
    resources :answers, shallow: true, except: %i[index], concerns: :voted do
      patch :mark_as_best, on: :member
    end
  end

  root to: 'questions#index'
end
