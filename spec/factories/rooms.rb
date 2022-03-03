# frozen_string_literal: true

FactoryBot.define do
  factory :room do
    sequence(:title) { |i| "Room ##{i}" }
    description { Faker::Lorem.sentence }
  end
end
