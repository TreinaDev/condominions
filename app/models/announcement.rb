class Announcement < ApplicationRecord
  validates :title, presence: true, length: { maximum: 50 }
  validates :message, presence: true

  belongs_to :manager
  belongs_to :condo

  has_rich_text :message
end
