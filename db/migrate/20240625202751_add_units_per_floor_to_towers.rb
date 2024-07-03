class AddUnitsPerFloorToTowers < ActiveRecord::Migration[7.1]
  def change
    add_column :towers, :units_per_floor, :integer
  end
end
