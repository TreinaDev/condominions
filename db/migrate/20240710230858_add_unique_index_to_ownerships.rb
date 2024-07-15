class AddUniqueIndexToOwnerships < ActiveRecord::Migration[7.1]
  def change
    add_index :ownerships, [:resident_id, :unit_id], unique: true
  end
end
