class CreateAddresses < ActiveRecord::Migration[7.1]
  def change
    create_table :addresses do |t|
      t.string :public_place
      t.string :number
      t.string :neighborhood
      t.string :city
      t.string :state
      t.string :zip

      t.timestamps
    end
  end
end
