class Unit < ApplicationRecord
  belongs_to :unit_type, optional: true
  belongs_to :floor
  belongs_to :owner, class_name: 'Resident', inverse_of: :properties, optional: true
  belongs_to :tenant, class_name: 'Resident', inverse_of: :residence, optional: true

  delegate :tower, to: :floor, allow_nil: true
  delegate :condo, to: :tower, allow_nil: true

  def print_identifier
    "Unidade #{short_identifier}"
  end

  def short_identifier
    "#{floor.identifier}#{floor.units.index(self) + 1}"
  end

  def identifier
    floor.units.index(self) + 1
  end

  def tower_identifier
    "#{floor.tower.name} - #{short_identifier}"
  end

  def unit_json
    area, unit_type_id, description = set_unit_type_info
    {
      id:, area:,
      floor: floor.identifier, number: short_identifier,
      unit_type_id:, condo_id: condo.id,
      condo_name: condo.name, tenant_id: tenant&.id,
      owner_id: owner&.id, description:
    }
  end

  def set_unit_type_info
    area = unit_type&.metreage
    unit_type_id = unit_type&.id
    description = unit_type&.description
    [area, unit_type_id, description]
  end
end
