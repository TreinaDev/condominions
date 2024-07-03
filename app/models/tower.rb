class Tower < ApplicationRecord
  belongs_to :condo
  has_many :floors, dependent: :destroy

  validates :name, :floor_quantity, :units_per_floor, presence: true

  validates :floor_quantity, :units_per_floor, numericality: {
    greater_than: 0, only_integer: true
  }

  after_create :generate_floors

  def generate_floors
    floor_quantity.times { create_floor_with_units }
  end

  private

  def create_floor_with_units
    floor = Floor.create tower: self
    floor.generate_units
  end
end
