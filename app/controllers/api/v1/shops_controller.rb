# frozen_string_literal: true

class Api::V1::ShopsController < ApplicationController
  def index
    @shops = Shop.all

    render json: { status: "success", shops: @shops }
  end
end
