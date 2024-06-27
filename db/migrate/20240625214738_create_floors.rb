class CreateFloors < ActiveRecord::Migration[7.1]
  def change
    create_table :floors do |t|
      t.references :tower, null: false, foreign_key: true

      t.timestamps
    end
  end
end
