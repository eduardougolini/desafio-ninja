# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'API V1 Appointments', type: :request do
  before { Timecop.freeze '2022-03-03 21:00:00' }
  after { Timecop.return }

  describe 'GET /api/v1/rooms/{room_id}/appointments' do
    context 'when there is no appointment registered for the room' do
      it 'returns an empty array' do
        room = create(:room)

        get "/api/v1/rooms/#{room.id}/appointments"

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['data']).to match_array([])
      end
    end

    context 'when there is an appointment registered for the room' do
      it 'returns the rooms data' do
        appointment = create(:appointment)

        get "/api/v1/rooms/#{appointment.room.id}/appointments"

        expected_response = [{
          id: appointment.id,
          type: 'appointment',
          attributes: {
            start_at: appointment.start_at,
            end_at: appointment.end_at
          },
          relationships: {
            room: {
              data: {
                id: appointment.room.id,
                type: 'room'
              }
            }
          }
        }]

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body, symbolize_names: true)[:data]).to match_array(expected_response)
      end
    end
  end

  describe 'GET /api/v1/rooms/{room_id}/appointments/{appointment_id}' do
    context 'when the appointment_id doesn\'t exists' do
      it 'returns an :not_found http code' do
        room = create(:room)

        get "/api/v1/rooms/#{room.id}/appointments/#{Faker::Internet.uuid}"

        expect(response).to have_http_status(:not_found)
      end
    end

    context 'when there is an appointment for the appointment_id informed' do
      it 'returns the appointment data' do
        appointment = create(:appointment)

        get "/api/v1/rooms/#{appointment.room.id}/appointments/#{appointment.id}"

        expected_response = {
          id: appointment.id,
          type: 'appointment',
          attributes: {
            start_at: appointment.start_at,
            end_at: appointment.end_at
          },
          relationships: {
            room: {
              data: {
                id: appointment.room.id,
                type: 'room'
              }
            }
          }
        }

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body, symbolize_names: true)[:data]).to match_array(expected_response)
      end
    end
  end

  describe 'POST /api/v1/rooms/{room_id}/appointments' do
    context 'when the params are invalid' do
      it 'returns an :unprocessable_entity http code' do
        room = create(:room)

        post "/api/v1/rooms/#{room.id}/appointments", params: {
          start_at: Time.current
        }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['error']).to eq('Param is missing or the value is empty')
      end
    end

    context 'when the params are valid' do
      it 'creates a new appointment' do
        room = create(:room)
        start_at = 1.business_hour.from_now
        end_at = 2.business_hour.from_now

        post "/api/v1/rooms/#{room.id}/appointments", params: {
          appointment: {
            start_at:,
            end_at:
          }
        }

        expected_response = {
          id: anything,
          type: 'appointment',
          attributes: {
            start_at:,
            end_at:
          },
          relationships: {
            room: {
              data: {
                id: room.id,
                type: 'room'
              }
            }
          }
        }

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body, symbolize_names: true)[:data]).to match_array(expected_response)
      end
    end
  end

  describe 'PUT /api/v1/rooms/{room_id}/appointments/{appointment_id}' do
    context 'when the params are invalid' do
      it 'returns an :unprocessable_entity http code' do
        appointment = create(:appointment)

        put "/api/v1/rooms/#{appointment.room.id}/appointments/#{appointment.id}", params: {
          start_at: Time.current
        }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['error']).to eq('Param is missing or the value is empty')
      end
    end

    context 'when the params are valid' do
      it 'updates the appointment' do
        appointment = create(:appointment)
        start_at = 5.business_hour.from_now
        end_at = 6.business_hour.from_now

        put "/api/v1/rooms/#{appointment.room.id}/appointments/#{appointment.id}", params: {
          appointment: {
            start_at:,
            end_at:
          }
        }

        expected_response = {
          id: appointment.id,
          type: 'appointment',
          attributes: {
            start_at:,
            end_at:
          },
          relationships: {
            room: {
              data: {
                id: appointment.room.id,
                type: 'room'
              }
            }
          }
        }

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body, symbolize_names: true)[:data]).to match_array(expected_response)
      end
    end
  end

  describe 'DELETE /api/v1/rooms/{room_id}/appointments/{appointment_id}' do
    it 'deletes the appointment based on appointment_id param' do
      appointment = create(:appointment)

      delete "/api/v1/rooms/#{appointment.room.id}/appointments/#{appointment.id}"

      expect(response).to have_http_status(:no_content)
    end
  end
end
