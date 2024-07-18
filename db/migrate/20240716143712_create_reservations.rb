class CreateReservations < ActiveRecord::Migration[7.1]
  def change
    create_table :reservations do |t|
      t.date :date, null: false
      t.integer :status, default: 0, null: false
      t.references :common_area, null: false, foreign_key: true
      t.references :resident, null: false, foreign_key: true

      t.timestamps
    end
  end
end
