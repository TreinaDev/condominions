class AddResidenceToResidents < ActiveRecord::Migration[7.1]
  def change
    add_reference :residents, :residence, foreign_key: { to_table: :units }
  end
end
