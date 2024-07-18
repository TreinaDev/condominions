class Announcement < ApplicationRecord
  validates :title, :message, presence: true

  belongs_to :manager
  belongs_to :condo
end
