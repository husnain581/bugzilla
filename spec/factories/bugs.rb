# frozen_string_literal: true

FactoryBot.define do
  factory :bug do
    title { Faker::Lorem.characters(number: 5) }
    description { Faker::Lorem.sentence }
    deadline { Time.zone.today }
    project { Project.first }
    user { create(:user) }
    image { Rack::Test::UploadedFile.new('app/assets/images/bug.png', 'bug.png') }
    bug_type { 1 }
    status { 1 }
  end
end
