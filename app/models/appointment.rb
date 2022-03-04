# frozen_string_literal: true

# Model that represents the scheduled appointments for an specified room
class Appointment < ApplicationRecord
  belongs_to :room

  validates :start_at, :end_at, presence: true
  validates :start_at, comparison: { greater_than: :end_at }

  validate :occurs_in_the_same_day
  validate :occurs_during_business_hours

  private

  def occurs_in_the_same_day
    return if start_at.to_s.to_date == end_at.to_s.to_date

    errors.add(:base, :different_days)
  end

  def occurs_during_business_hours
    return if start_at&.during_business_hours? && end_at&.during_business_hours?

    errors.add(:base, :out_of_business_hours)
  end
end
