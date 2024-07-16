class CreateCondoManagers < ActiveRecord::Migration[7.1]
  def change
    create_table :condo_managers do |t|
      t.references :manager, null: false, foreign_key: true
      t.references :condo, null: false, foreign_key: true

      t.timestamps
    end
    add_index :condo_managers, [:manager_id, :condo_id], unique: true
  end
end
