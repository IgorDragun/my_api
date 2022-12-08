# frozen_string_literal: true

FactoryBot.define do
  factory :user, class: "User" do
    name { "User" }
    email { "user@gmail.com" }
    balance { 1000.00 }
    password { "12345678" }
    password_confirmation { "12345678" }
    token { "123qwe123qwe123qwe123qwe123qwe12" }
  end
end
