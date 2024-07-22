class CreateSingleCharges < ActiveRecord::Migration[7.1]
  def change
    create_table :single_charges do |t|
      t.text :description
      t.integer :value_cents, null: false
      t.integer :charge_type, null: false
      t.references :condo, null: false, foreign_key: true
      t.references :unit, null: false, foreign_key: true
      t.references :common_area, null: true, foreign_key: true

      t.timestamps
    end
  end
end
