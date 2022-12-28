# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :users, only: :create
      resources :inventories, only: :index
      resources :shops, only: :index do
        resources :items, only: :index do
          get "show"
          post "buy_item"
        end
      end
      resources :trades, only: :create do
        get "active_trades", on: :collection
        get "passive_trades", on: :collection
        post "cancel"
        post "decline"
      end
    end
  end
end
