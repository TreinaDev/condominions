class CreateVisitorEntries < ActiveRecord::Migration[7.1]
  def change
    create_table :visitor_entries do |t|
      t.references :condo, null: false, foreign_key: true
      t.string :full_name
      t.string :identity_number
      t.references :unit, foreign_key: true

      t.timestamps
    end
  end
end
