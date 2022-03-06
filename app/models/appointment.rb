# frozen_string_literal: true

# Model that represents the scheduled appointments for an specified room
class Appointment < ApplicationRecord
  belongs_to :room

  validates :start_at, :end_at, presence: true
  validates :end_at, comparison: { greater_than: :start_at }

  validate :occurs_in_the_same_day
  validate :occurs_during_business_hours
  validate :already_scheduled

  private

  def occurs_in_the_same_day
    return if start_at.to_s.to_date == end_at.to_s.to_date

    errors.add(:base, :different_days)
  end

  def occurs_during_business_hours
    return if start_at&.during_business_hours? && end_at&.during_business_hours?

    errors.add(:base, :out_of_business_hours)
  end

  def already_scheduled
    return if room.nil?

    appointments = room.appointments.find do |appointment|
      next if appointment.id.nil?

      (start_at..end_at).overlaps?(appointment.start_at..appointment.end_at)
    end

    errors.add(:base, :already_scheduled) if appointments.present?
  end
end
