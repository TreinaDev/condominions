class AddStatusToResidents < ActiveRecord::Migration[7.1]
  def change
    add_column :residents, :status, :integer, default: 0
  end
end
