class Announcement < ApplicationRecord
  validates :title, :message, presence: true

  belongs_to :manager
  belongs_to :condo

  has_rich_text :message
end
