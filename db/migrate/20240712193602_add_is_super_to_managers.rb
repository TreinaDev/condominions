class AddIsSuperToManagers < ActiveRecord::Migration[7.1]
  def change
    unless column_exists?(:managers, :is_super)
      add_column :managers, :is_super, :boolean, default: false
    end
  end
end
