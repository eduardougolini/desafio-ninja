# frozen_string_literal: true

module API
  module V1
    # Controller responsible for the rooms management
    class RoomsController < ApplicationController
      def index
        render json: RoomSerializer.new(Room.all), status: :ok
      end

      def show
        room = Room.find(params[:id])

        render json: RoomSerializer.new(room), status: :ok
      end

      def create
        room = Room.new(resource_params)

        if room.save
          render json: RoomSerializer.new(room), status: :ok
        else
          render json: { error: room.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        room = Room.find(params[:id])

        if room.update(resource_params)
          render json: RoomSerializer.new(room), status: :ok
        else
          render json: { error: room.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        room = Room.find(params[:id])
        room.destroy!

        head :no_content
      end

      private

      def resource_params
        params.require(:room).permit(:title, :description)
      end
    end
  end
end
