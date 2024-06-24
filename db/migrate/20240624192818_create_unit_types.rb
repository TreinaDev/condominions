class CreateUnitTypes < ActiveRecord::Migration[7.1]
  def change
    create_table :unit_types do |t|
      t.text :description
      t.integer :metreage
      t.references :tower, null: false, foreign_key: true

      t.timestamps
    end
  end
end
