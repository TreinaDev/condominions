class CreateResidents < ActiveRecord::Migration[7.1]
  def change
    create_table :residents do |t|
      t.string :full_name
      t.string :registration_number

      t.timestamps
    end
  end
end
