# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'api/v1/rooms/{room_id}/appointments', type: :request do
  before { Timecop.freeze '2022-03-03 21:00:00' }
  after { Timecop.return }

  path '/api/v1/rooms/{room_id}/appointments' do
    parameter name: 'room_id', in: :path, type: :string, description: 'room_id'

    get('list appointments') do
      tags 'Appointments'
      response(200, 'returns all appointments for the room') do
        schema '$ref' => '#/components/schemas/appointments'

        let(:appointment) { create(:appointment) }
        let(:room_id) { appointment.room.id }

        run_test!
      end
    end

    post('create appointment') do
      tags 'Appointments'
      consumes 'application/json'
      parameter name: :appointment, in: :body, schema: {
        type: :object,
        properties: {
          start_at: { type: :string },
          end_at: { type: :string }
        },
        required: %w[start_at end_at]
      }

      response(200, 'succesfully creates a new appointment') do
        schema '$ref' => '#/components/schemas/appointment'

        let(:room_id) { create(:room).id }
        let(:appointment) do
          {
            start_at: 1.business_hour.from_now,
            end_at: 2.business_hour.from_now
          }
        end

        run_test!
      end
    end
  end

  path '/api/v1/rooms/{room_id}/appointments/{appointment_id}' do
    parameter name: 'room_id', in: :path, type: :string, description: 'room_id'
    parameter name: 'appointment_id', in: :path, type: :string, description: 'appointment_id'

    get('show appointment') do
      tags 'Appointments'
      response(200, 'returns the appointment data') do
        schema '$ref' => '#/components/schemas/appointment'

        let(:appointment) { create(:appointment) }
        let(:appointment_id) { appointment.id }
        let(:room_id) { appointment.room.id }

        run_test!
      end
    end

    put('update appointment') do
      tags 'Appointments'
      consumes 'application/json'
      parameter name: :appointment, in: :body, schema: {
        type: :object,
        properties: {
          start_at: { type: :string },
          end_at: { type: :string }
        }
      }
      response(200, 'updates an appointment') do
        schema '$ref' => '#/components/schemas/appointment'

        let(:appointment_object) { create(:appointment) }
        let(:appointment_id) { appointment_object.id }
        let(:room_id) { appointment_object.room.id }
        let(:appointment) do
          {
            start_at: 5.business_hour.from_now,
            end_at: 6.business_hour.from_now
          }
        end

        run_test!
      end
    end

    delete('delete appointment') do
      tags 'Appointments'
      response(204, 'deletes an appointment') do
        let(:appointment) { create(:appointment) }
        let(:appointment_id) { appointment.id }
        let(:room_id) { appointment.room.id }

        run_test!
      end
    end
  end
end
