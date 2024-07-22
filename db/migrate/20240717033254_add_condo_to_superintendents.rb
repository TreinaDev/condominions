class AddCondoToSuperintendents < ActiveRecord::Migration[7.1]
  def change
    add_reference :superintendents, :condo, null: false, foreign_key: true
  end
end
