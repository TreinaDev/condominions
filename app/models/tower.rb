class Tower < ApplicationRecord
  belongs_to :condo
  has_many :floors, dependent: :destroy

  validates :name, :floor_quantity, :units_per_floor, presence: true

  validates :floor_quantity, :units_per_floor, numericality: {
    greater_than: 0, only_integer: true
  }

  def generate_floors
    floor_quantity.times { (Floor.create tower: self).generate_units }
  end
end
