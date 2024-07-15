class CreateOwnerships < ActiveRecord::Migration[7.1]
  def change
    create_table :ownerships do |t|
      t.references :unit, null: false, foreign_key: true
      t.references :resident, null: false, foreign_key: true

      t.timestamps
    end
  end
end
