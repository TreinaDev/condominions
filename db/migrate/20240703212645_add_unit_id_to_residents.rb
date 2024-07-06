class AddUnitIdToResidents < ActiveRecord::Migration[7.1]
  def change
    add_reference :residents, :unit, null: false, foreign_key: true
  end
end
