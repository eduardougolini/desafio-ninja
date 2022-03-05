# frozen_string_literal: true

module API
  module V1
    class RoomSerializer
      include JSONAPI::Serializer

      attributes :title, :description

      has_many :appointments
    end
  end
end
