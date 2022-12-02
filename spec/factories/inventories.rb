FactoryBot.define do
  factory :inventory, class: "Inventory" do
    name { "First inventory" }
    cost { 100.00 }
  end
end
