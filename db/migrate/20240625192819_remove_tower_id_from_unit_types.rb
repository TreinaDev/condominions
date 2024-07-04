class RemoveTowerIdFromUnitTypes < ActiveRecord::Migration[7.1]
  def change
    remove_column :unit_types, :tower_id, :integer
  end
end
