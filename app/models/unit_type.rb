class UnitType < ApplicationRecord
  has_many :units, dependent: :destroy
  belongs_to :condo

  validates :description, :metreage, presence: true
  validates :metreage, numericality: { greater_than: 0 }

  after_update :update_fraction, if: :metreage_previously_changed?

  def metreage_to_square_meters
    "#{metreage}m²"
  end

  def fraction_to_percentage
    return 'Não definida' if fraction.nil?

    "#{fraction}%"
  end

  def unit_ids
    units.pluck :id
  end

  private

  def update_fraction
    condo.set_unit_types_fractions
  end
end
