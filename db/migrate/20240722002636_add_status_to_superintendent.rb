class AddStatusToSuperintendent < ActiveRecord::Migration[7.1]
  def change
    add_column :superintendents, :status, :integer
  end
end
