class UnitType < ApplicationRecord
  validates :description, :metreage, presence: true
  validates :metreage, numericality: { greater_than: 0 }

  def p_metreage
    "#{metreage}m²"
  end
end
