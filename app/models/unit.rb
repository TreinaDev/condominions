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
end
