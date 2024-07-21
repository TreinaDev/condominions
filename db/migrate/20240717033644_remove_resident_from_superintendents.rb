class RemoveResidentFromSuperintendents < ActiveRecord::Migration[7.1]
  def change
    remove_reference :superintendents, :resident, null: false, foreign_key: true
  end
end
