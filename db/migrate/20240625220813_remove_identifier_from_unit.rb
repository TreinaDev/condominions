class RemoveIdentifierFromUnit < ActiveRecord::Migration[7.1]
  def change
    remove_column :units, :identifier, :string
  end
end
