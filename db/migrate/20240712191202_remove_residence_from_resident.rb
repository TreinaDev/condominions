class RemoveResidenceFromResident < ActiveRecord::Migration[7.1]
  def change
    remove_column :residents, :residence_id, :integer
  end
end
