class UnitType < ApplicationRecord
  validates :description, :metreage, presence: true

  validate :metreage_cannot_be_less_than_one

  private

  def metreage_cannot_be_less_than_one
    errors.add(:metreage, 'Metragem não pode ser igual ou menor que zero') if metreage.present? && metreage <= 0
  end
end
