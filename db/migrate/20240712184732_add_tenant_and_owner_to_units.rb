class AddTenantAndOwnerToUnits < ActiveRecord::Migration[7.1]
  def change
    add_reference :units, :tenant, foreign_key: { to_table: :residents }
    add_reference :units, :owner, foreign_key: { to_table: :residents }
  end
end
