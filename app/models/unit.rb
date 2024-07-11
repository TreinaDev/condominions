class Unit < ApplicationRecord
  belongs_to :unit_type, optional: true
  belongs_to :floor
  has_many :tenants, class_name: 'Resident', foreign_key: 'residence_id', dependent: :destroy, inverse_of: :resident
  has_many :ownerships, dependent: :destroy
  has_many :owners, through: :ownerships, source: :resident, dependent: :destroy

  delegate :tower, to: :floor, allow_nil: true
  delegate :condo, to: :tower, allow_nil: true

  def print_identifier
    "Unidade #{short_identifier}"
  end

  def short_identifier
    "#{floor.identifier}#{floor.units.index(self) + 1}"
  end
end
