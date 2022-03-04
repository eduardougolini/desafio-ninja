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

  describe '#occurs_in_the_same_day' do
    context 'when the start_at and end_at occurs in the same day' do
      it 'doesn\'t adds an error to the object' do
        appointment = build(:appointment)
        appointment.valid?

        expect(appointment.errors).to_not be_added(:base, :different_days)
      end
    end

    context 'when the start_at and end_at occurs in different days' do
      it 'adds an error to the object' do
        appointment = build(:appointment, start_at: Time.current, end_at: 1.day.from_now)
        appointment.valid?

        expect(appointment.errors).to be_added(:base, :different_days)
      end
    end
  end

  describe '#occurs_during_business_hours' do
    context 'when the start_at and end_at occurs during business hours' do
      it 'doesn\'t adds an error to the object' do
        appointment = build(:appointment)
        appointment.valid?

        expect(appointment.errors).to_not be_added(:base, :out_of_business_hours)
      end
    end

    context 'when the start_at and end_at occurs out of business hours' do
      before { Timecop.freeze '2022-03-03 21:00:00' }
      after { Timecop.return }

      it 'adds an error to the object' do
        appointment = build(:appointment, start_at: Time.current, end_at: 1.hour.from_now)
        appointment.valid?

        expect(appointment.errors).to be_added(:base, :out_of_business_hours)
      end
    end
  end
end
