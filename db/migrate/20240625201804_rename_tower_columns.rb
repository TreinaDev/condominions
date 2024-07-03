class RenameTowerColumns < ActiveRecord::Migration[7.1]
  def change
    rename_column :towers, :condominium_id, :condo_id
    rename_column :towers, :floors, :floor_quantity
  end
end
