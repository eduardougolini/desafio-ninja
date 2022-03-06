# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'API V1 Rooms', type: :request do
  describe 'GET /api/v1/rooms' do
    context 'when there is no room registered' do
      it 'returns an empty array' do
        allow(Room).to receive(:all).and_return([]).once

        get '/api/v1/rooms'

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['data']).to match_array([])
      end
    end

    context 'when there is rooms registered' do
      it 'returns the rooms data' do
        room = create(:room)
        allow(Room).to receive(:all).and_return([room]).once

        get '/api/v1/rooms'

        expected_response = [{
          id: room.id,
          type: 'room',
          attributes: {
            description: room.description,
            title: room.title
          },
          relationships: {
            appointments: {
              data: []
            }
          }
        }]

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body, symbolize_names: true)[:data]).to match_array(expected_response)
      end
    end
  end

  describe 'GET /api/v1/rooms/{room_id}' do
    context 'when the room_id doesn\'t exists' do
      it 'returns an :not_found http code' do
        get "/api/v1/rooms/#{Faker::Internet.uuid}"

        expect(response).to have_http_status(:not_found)
      end
    end

    context 'when there is a room for the room_id informed' do
      it 'returns the room data' do
        room = create(:room)

        get "/api/v1/rooms/#{room.id}"

        expected_response = {
          id: room.id,
          type: 'room',
          attributes: {
            description: room.description,
            title: room.title
          },
          relationships: {
            appointments: {
              data: []
            }
          }
        }

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body, symbolize_names: true)[:data]).to match_array(expected_response)
      end
    end
  end

  describe 'POST /api/v1/rooms' do
    context 'when the params are invalid' do
      it 'returns an :unprocessable_entity http code' do
        post '/api/v1/rooms', params: {
          title: Faker::Games::DnD.monster
        }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['error']).to eq('Param is missing or the value is empty')
      end
    end

    context 'when the params are valid' do
      it 'creates a new room' do
        title = Faker::Games::DnD.monster
        description = Faker::Books::Lovecraft.sentence

        post '/api/v1/rooms', params: {
          room: {
            title:,
            description:
          }
        }

        expected_response = {
          id: anything,
          type: 'room',
          attributes: {
            description:,
            title:
          },
          relationships: {
            appointments: {
              data: []
            }
          }
        }

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body, symbolize_names: true)[:data]).to match_array(expected_response)
      end
    end
  end

  describe 'PUT /api/v1/rooms/{room_id}' do
    context 'when the params are invalid' do
      it 'returns an :unprocessable_entity http code' do
        room = create(:room)

        put "/api/v1/rooms/#{room.id}", params: {
          title: Faker::Games::DnD.monster
        }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['error']).to eq('Param is missing or the value is empty')
      end
    end

    context 'when the params are valid' do
      it 'updates the room' do
        room = create(:room)
        title = Faker::Games::DnD.monster
        description = Faker::Books::Lovecraft.sentence

        put "/api/v1/rooms/#{room.id}", params: {
          room: {
            title:,
            description:
          }
        }

        expected_response = {
          id: room.id,
          type: 'room',
          attributes: {
            description:,
            title:
          },
          relationships: {
            appointments: {
              data: []
            }
          }
        }

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body, symbolize_names: true)[:data]).to match_array(expected_response)
      end
    end
  end

  describe 'DELETE /api/v1/rooms/{room_id}' do
    it 'deletes the room based on room_id param' do
      room = create(:room)

      delete "/api/v1/rooms/#{room.id}"

      expect(response).to have_http_status(:no_content)
    end
  end
end
