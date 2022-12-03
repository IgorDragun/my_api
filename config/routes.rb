# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :users, only: :create
      resources :inventories, only: :index
      resources :shops, only: :index do
        resources :items, only: :index
      end
    end
  end
end
