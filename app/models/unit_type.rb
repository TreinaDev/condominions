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
end
