# frozen_string_literal: true

class Appointment < ApplicationRecord
  belongs_to :room

  validates :start_at, :end_at, presence: true
end
