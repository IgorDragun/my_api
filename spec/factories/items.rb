# frozen_string_literal: true

FactoryBot.define do
  factory :item, class: "Item" do
    name { "First item" }
    price { 100.00 }
    count { 1 }
  end
end
