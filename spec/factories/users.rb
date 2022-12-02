FactoryBot.define do
  factory :user, class: "User" do
    # association(:inventories, factory: :inventory, strategy: :build)

    name { "User" }
    email { "user@gmail.com" }
    password { "12345678" }
    password_confirmation { "12345678" }
  end
end
