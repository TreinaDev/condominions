class UnitType < ApplicationRecord
  has_many :units, dependent: :destroy
  belongs_to :condo

  validates :description, :metreage, :fraction, presence: true
  validates :metreage, :fraction, numericality: { greater_than: 0 }

  def metreage_to_square_meters
    "#{metreage}m²"
  end

  def fraction_to_percentage
    "#{fraction}%"
  end
end
