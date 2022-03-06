# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'api/v1/rooms', type: :request do
  path '/api/v1/rooms' do
    get('list rooms') do
      tags 'Rooms'
      response(200, 'returns all registered rooms') do
        schema '$ref' => '#/components/schemas/rooms'

        run_test!
      end
    end

    post('create room') do
      tags 'Rooms'
      consumes 'application/json'
      parameter name: :room, in: :body, schema: {
        type: :object,
        properties: {
          title: { type: :string },
          description: { type: :string }
        },
        required: %w[title description]
      }

      response(200, 'succesfully creates a new room') do
        schema '$ref' => '#/components/schemas/room'

        let(:room) do
          {
            title: Faker::Games::DnD.monster,
            description: Faker::Books::Lovecraft.sentence
          }
        end

        run_test!
      end
    end
  end

  path '/api/v1/rooms/{id}' do
    parameter name: 'id', in: :path, type: :string, description: 'id'

    get('show room') do
      tags 'Rooms'
      response(200, 'returns the room data') do
        schema '$ref' => '#/components/schemas/room'

        let(:id) { create(:room).id }

        run_test!
      end
    end

    put('update room') do
      tags 'Rooms'
      consumes 'application/json'
      parameter name: :room, in: :body, schema: {
        type: :object,
        properties: {
          title: { type: :string },
          description: { type: :string }
        }
      }
      response(200, 'updates a room') do
        schema '$ref' => '#/components/schemas/room'

        let(:id) { create(:room).id }
        let(:room) do
          {
            title: Faker::Games::DnD.monster,
            description: Faker::Books::Lovecraft.sentence
          }
        end

        run_test!
      end
    end

    delete('delete room') do
      tags 'Rooms'
      response(204, 'deletes a room') do
        let(:id) { create(:room).id }

        run_test!
      end
    end
  end
end
