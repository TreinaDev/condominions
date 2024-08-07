class SingleCharge < ApplicationRecord
  belongs_to :condo
  belongs_to :unit
  belongs_to :common_area, optional: true

  validates :value_cents, :charge_type, presence: true
  validates :description, presence: true, if: -> { charge_type == 'fine' }

  validate :unit_valid?

  enum charge_type: { fine: 0, common_area_fee: 1 }

  monetize :value_cents, as: :value, with_model_currency: :currency

  private

  def unit_valid?
    return true if unit&.owner

    errors.add(:unit, 'não possui um proprietário.')
  end
end
