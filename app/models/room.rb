# frozen_string_literal: true

class Room < ApplicationRecord
  has_many :appointments, dependent: :destroy

  validates :title, :description, presence: true
end
