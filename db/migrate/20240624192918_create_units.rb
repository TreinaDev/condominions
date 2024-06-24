class CreateUnits < ActiveRecord::Migration[7.1]
  def change
    create_table :units do |t|
      t.string :identifier
      t.references :unit_type, null: false, foreign_key: true

      t.timestamps
    end
  end
end
