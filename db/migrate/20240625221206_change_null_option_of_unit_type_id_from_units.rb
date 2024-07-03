class ChangeNullOptionOfUnitTypeIdFromUnits < ActiveRecord::Migration[7.1]
  def change
    change_column_null :units, :unit_type_id, true
  end
end
