# frozen_string_literal: true

class Room < ApplicationRecord
  validates :title, :description, presence: true
end
