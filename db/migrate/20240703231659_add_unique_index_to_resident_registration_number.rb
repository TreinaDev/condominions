class AddUniqueIndexToResidentRegistrationNumber < ActiveRecord::Migration[7.1]
  def change
    add_index :residents, :registration_number, unique: true
  end
end
