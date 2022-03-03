# frozen_string_literal: true

FactoryBot.define do
  factory :appointment do
    start_at { 1.business_hour.from_now }
    end_at { 2.business_hour.from_now }
    room
  end
end
