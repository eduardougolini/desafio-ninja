# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Appointment, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:start_at) }
    it { is_expected.to validate_presence_of(:end_at) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:room).required }
  end
end
