# frozen_string_literal: true

# Migration that adds the rooms table to the database
class CreateRooms < ActiveRecord::Migration[7.0]
  def change
    create_table :rooms, id: :uuid do |t|
      t.string :title, limit: 100, null: false
      t.string :description, limit: 255, null: false

      t.timestamps
    end
  end
end
