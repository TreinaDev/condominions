class UnitType < ApplicationRecord
  has_many :units, dependent: :destroy

  validates :description, :metreage, presence: true
  validates :metreage, numericality: { greater_than: 0 }

  def p_metreage
    "#{metreage}m²"
  end
end
