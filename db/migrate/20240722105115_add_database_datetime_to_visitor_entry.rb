class AddDatabaseDatetimeToVisitorEntry < ActiveRecord::Migration[7.1]
  def change
    add_column :visitor_entries, :database_datetime, :datetime, null: false
  end
end
