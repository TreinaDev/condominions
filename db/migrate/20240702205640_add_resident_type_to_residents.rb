class AddResidentTypeToResidents < ActiveRecord::Migration[7.1]
  def change
    add_column :residents, :resident_type, :integer
  end
end
