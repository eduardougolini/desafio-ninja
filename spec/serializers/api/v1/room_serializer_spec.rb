# frozen_string_literal: true

require 'rails_helper'

RSpec.describe API::V1::RoomSerializer do
  describe 'Room Serializer' do
    context 'when a room is serialized' do
      it 'returns an json:api response' do
        room = create(:room)

        serialized_hash = described_class.new(room).serializable_hash

        expected_data = {
          id: room.id,
          type: :room,
          attributes: {
            title: room.title,
            description: room.description
          }, relationships: {
            appointments: {
              data: []
            }
          }
        }

        expect(serialized_hash[:data]).to eq(expected_data)
      end

      context 'and has appointments' do
        it 'returns an json:api response' do
          appointment = create(:appointment)
          room = appointment.room.reload

          serialized_hash = described_class.new(room, include: [:appointments]).serializable_hash

          expected_data = {
            data: {
              id: room.id,
              type: :room,
              attributes: {
                title: room.title,
                description: room.description
              }, relationships: {
                appointments: {
                  data: [
                    id: appointment.id,
                    type: :appointment
                  ]
                }
              }
            },
            included: [{
              id: appointment.id,
              type: :appointment,
              attributes: {
                start_at: appointment.start_at,
                end_at: appointment.end_at
              },
              relationships: {
                room: {
                  data: {
                    id: room.id,
                    type: :room
                  }
                }
              }
            }]
          }

          expect(serialized_hash).to eq(expected_data)
        end
      end
    end
  end
end
