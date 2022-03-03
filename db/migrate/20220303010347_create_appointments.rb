class CreateAppointments < ActiveRecord::Migration[7.0]
  def change
    create_table :appointments, id: :uuid do |t|
      t.datetime :start_at, null: false
      t.datetime :end_at, null: false
      t.references :room, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
