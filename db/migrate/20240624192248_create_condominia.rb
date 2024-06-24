class CreateCondominia < ActiveRecord::Migration[7.1]
  def change
    create_table :condominia do |t|
      t.string :name
      t.string :registration_number
      t.references :address, null: false, foreign_key: true

      t.timestamps
    end
  end
end
