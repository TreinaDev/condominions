class AddCondoToVisitors < ActiveRecord::Migration[7.1]
  def change
    add_reference :visitors, :condo, null: false, foreign_key: true
  end
end
