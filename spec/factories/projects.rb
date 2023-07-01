# frozen_string_literal: true

FactoryBot.define do
  factory :project do
    name { Faker::Lorem.characters(number: 6) }
    users { build_list :user, 1 }
  end
end
