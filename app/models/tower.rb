class Tower < ApplicationRecord
  belongs_to :condo
  has_many :floors

  validates :name, :floor_quantity, :units_per_floor, :condo, presence: true

  validates :floor_quantity, :units_per_floor, numericality: {
    greater_than_or_equal_to: 0, only_integer: true
  }
end
