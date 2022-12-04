# frozen_string_literal: true

class Api::V1::ItemsController < ApplicationController
  def index
    @shop = Shop.find_by(id: params[:shop_id].to_i)

    if @shop
      @items = @shop.items
      render json: { status: "success", items: @items }
    else
      render json: { status: "failure", error: "Shop does not exist" }, status: :unprocessable_entity
    end
  end

  def show
    @shop = Shop.find_by(id: params[:shop_id].to_i)

    if @shop
      @item = @shop.items.find_by(id: params[:id])
      render json: { status: "success", item: @item }
    else
      render json: { status: "failure", error: "Shop does not exist" }, status: :unprocessable_entity
    end
  end
end
