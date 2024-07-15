class RemoveResidentTypeFromResidents < ActiveRecord::Migration[7.1]
  def change
    remove_column :residents, :resident_type, :integer
  end
end
