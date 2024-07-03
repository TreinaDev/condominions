class AddUniqueIndexToManagersRegistrationNumber < ActiveRecord::Migration[7.1]
  def change
    add_index :managers, :registration_number, unique: true
  end
end
