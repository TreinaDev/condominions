class RemoveUnitFromResidents < ActiveRecord::Migration[7.1]
  def change
    remove_column :residents, :unit_id, :integer
  end
end
