class AddFloorToUnits < ActiveRecord::Migration[7.1]
  def change
    add_reference :units, :floor, null: false, foreign_key: true
  end
end
