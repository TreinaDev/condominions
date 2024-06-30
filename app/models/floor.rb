class Floor < ApplicationRecord
  belongs_to :tower
  has_many :units, dependent: :destroy

  def generate_units
    tower.units_per_floor.times { Unit.create floor: self }
  end

  def print_identifier
    "#{tower.floors.index(self) + 1}º Andar"
  end
end
