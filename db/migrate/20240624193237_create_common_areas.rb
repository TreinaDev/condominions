class CreateCommonAreas < ActiveRecord::Migration[7.1]
  def change
    create_table :common_areas do |t|
      t.string :name
      t.text :description
      t.integer :max_occupancy
      t.text :rules
      t.references :condominium, null: false, foreign_key: true

      t.timestamps
    end
  end
end
