# frozen_string_literal: true

module API
  module V1
    # Controller responsible for the appointments management
    class AppointmentsController < ApplicationController
      def index
        render json: AppointmentSerializer.new(room.appointments), status: :ok
      end

      def show
        appointment = room.appointments.find(params[:id])

        render json: AppointmentSerializer.new(appointment), status: :ok
      end

      def create
        appointment = room.appointments.new(resource_params)

        if appointment.save
          render json: AppointmentSerializer.new(appointment), status: :ok
        else
          render json: { error: appointment.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        appointment = room.appointments.find(params[:id])

        if appointment.update(resource_params)
          render json: AppointmentSerializer.new(appointment), status: :ok
        else
          render json: { error: appointment.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        appointment = room.appointments.find(params[:id])
        appointment.destroy!

        head :no_content
      end

      private

      def room
        @room ||= Room.find(params['room_id'])
      end

      def resource_params
        params.require(:appointment).permit(:start_at, :end_at)
      end
    end
  end
end
