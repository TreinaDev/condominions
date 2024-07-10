class UnitType < ApplicationRecord
  has_many :units, dependent: :destroy
  belongs_to :condo

  validates :description, :metreage, presence: true
  validates :metreage, numericality: { greater_than: 0 }

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

  def self.update_fractions(condo)
    total_area = condo.calculate_total_area
    condo.unit_types.each do |unit_type|
      fraction = (unit_type.metreage / total_area * 100).round(5)
      unit_type.update!(fraction:)
    end
  end
end
