# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Room, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:description) }
  end

  describe 'associations' do
    it { is_expected.to have_many(:appointments).dependent(:destroy) }
  end
end
