class Floor < ApplicationRecord
  belongs_to :tower
  has_many :units, dependent: :destroy

  def generate_units
    tower.units_per_floor.times { Unit.create floor: self }
  end

  def identifier
    tower.floors.index(self) + 1
  end

  def return_unit_types
    units.includes(:unit_type)
         .order('unit_types.description')
         .map(&:unit_type)
         .uniq
         .compact
  end
end
