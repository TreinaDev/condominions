class AddSingleChargeIdToReservations < ActiveRecord::Migration[7.1]
  def change
    add_column :reservations, :single_charge_id, :integer
  end
end
