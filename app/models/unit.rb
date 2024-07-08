class Unit < ApplicationRecord
  belongs_to :unit_type, optional: true
  belongs_to :floor
  has_many :residents, dependent: :destroy

  def print_identifier
    "Unidade #{floor.identifier}#{floor.units.index(self) + 1}"
  end
end
