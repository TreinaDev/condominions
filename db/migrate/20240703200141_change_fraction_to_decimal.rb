class ChangeFractionToDecimal < ActiveRecord::Migration[7.1]
  def change
    change_column :unit_types, :fraction, :decimal, precision: 10, scale: 5
  end
end