class AddStatusToVisitor < ActiveRecord::Migration[7.1]
  def change
    add_column :visitors, :status, :integer, default: 0
  end
end
