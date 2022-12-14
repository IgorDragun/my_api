# frozen_string_literal: true

FactoryBot.define do
  factory :trade, class: "Trade" do
    buyer_id { 1 }
    seller_id { 2 }
    seller_inventory_id { 1 }
    offered_price { 10.00 }
    status { 1 }
  end
end
