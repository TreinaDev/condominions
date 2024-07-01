class RenameCondominiumToCondo < ActiveRecord::Migration[7.1]
  def change
    rename_column :common_areas, :condominium_id, :condo_id
  end
end
