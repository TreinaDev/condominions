class CreateVisitors < ActiveRecord::Migration[7.1]
  def change
    create_table :visitors do |t|
      t.string :full_name
      t.string :identity_number
      t.integer :category
      t.date :visit_date
      t.integer :recurrence
      t.references :resident, null: false, foreign_key: true

      t.timestamps
    end
  end
end
