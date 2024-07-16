class CommonArea < ApplicationRecord
  belongs_to :condo
  has_many :reservations, dependent: :destroy

  validates :name, :description, :max_occupancy, presence: true
  validates :max_occupancy, numericality: { greater_than: 0 }
end
