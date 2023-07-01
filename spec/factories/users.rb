# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name { Faker::Lorem.characters(number: 6) }
    email { "#{Faker::Internet.user_name}@gmail.com" }
    password { 'qwerty' }
    password_confirmation { 'qwerty' }
    user_type { 1 }
  end
end
