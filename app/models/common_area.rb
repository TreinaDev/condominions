class CommonArea < ApplicationRecord
  belongs_to :condo

  validates :name, :description, :max_occupancy, presence: true
  validates :max_occupancy, numericality: { greater_than: 0 }
end
