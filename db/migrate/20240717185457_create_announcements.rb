class CreateAnnouncements < ActiveRecord::Migration[7.1]
  def change
    create_table :announcements do |t|
      t.string :title
      t.text :message
      t.references :manager, null: false, foreign_key: true
      t.references :condo, null: false, foreign_key: true

      t.timestamps
    end
  end
end
