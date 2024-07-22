class AddTenantToSuperintendents < ActiveRecord::Migration[7.1]
  def change
    add_reference :superintendents, :tenant, null: false, foreign_key: { to_table: :residents }
  end
end
