class ChangeMetreageToDecimal < ActiveRecord::Migration[7.1]
  def change
    change_column :unit_types, :metreage, :decimal, precision: 10, scale: 2
  end
end
