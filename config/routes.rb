# frozen_string_literal: true
require "sidekiq/web"

Rails.application.routes.draw do
  mount Sidekiq::Web => "/sidekiq"

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
        post "accept"
        post "cancel"
        post "decline"
      end
      resources :items do
        get "statistic", on: :collection
      end
    end
  end
end
