# frozen_string_literal: true

FactoryBot.define do
  factory :item, class: "Item" do
    name { "Name" }
    price { 100.00 }
    count { 10 }
  end
end
