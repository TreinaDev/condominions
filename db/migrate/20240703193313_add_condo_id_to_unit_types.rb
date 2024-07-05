class AddCondoIdToUnitTypes < ActiveRecord::Migration[7.1]
  def change
    add_reference :unit_types, :condo, null: false, foreign_key: true
  end
end
