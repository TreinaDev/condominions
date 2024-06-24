class CreateTowers < ActiveRecord::Migration[7.1]
  def change
    create_table :towers do |t|
      t.integer :floors
      t.string :name
      t.references :condominium, null: false, foreign_key: true

      t.timestamps
    end
  end
end
