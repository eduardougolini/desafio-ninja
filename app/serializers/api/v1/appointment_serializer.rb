# frozen_string_literal: true

module API
  module V1
    class AppointmentSerializer
      include JSONAPI::Serializer

      attributes :start_at, :end_at

      belongs_to :room
    end
  end
end
