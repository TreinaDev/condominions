class AddUniqueToRegistrationNumberInCondo < ActiveRecord::Migration[7.1]
  def change
    add_index :condos, :registration_number, unique: true
  end
end
