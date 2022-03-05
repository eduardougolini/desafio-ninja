# frozen_string_literal: true

require 'rails_helper'

RSpec.describe API::V1::AppointmentSerializer do
  describe 'Appointment Serializer' do
    context 'when an appointment is serialized' do
      it 'returns an json:api response' do
        appointment = create(:appointment)

        serialized_hash = described_class.new(appointment).serializable_hash

        expected_data = {
          id: appointment.id,
          type: :appointment,
          attributes: {
            start_at: appointment.start_at,
            end_at: appointment.end_at
          }, relationships: {
            room: {
              data: {
                id: appointment.room_id,
                type: :room
              }
            }
          }
        }

        expect(serialized_hash[:data]).to eq(expected_data)
      end
    end
  end
end
