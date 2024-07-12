class DropOwnerships < ActiveRecord::Migration[7.1]
  def change
    drop_table :ownerships
  end
end
