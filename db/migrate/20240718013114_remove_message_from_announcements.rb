class RemoveMessageFromAnnouncements < ActiveRecord::Migration[7.1]
  def change
    remove_column :announcements, :message, :text
  end
end
