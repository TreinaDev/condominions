class SingleCharge < ApplicationRecord
  belongs_to :condo
  belongs_to :unit
  belongs_to :common_area, optional: true

  validates :value_cents, :charge_type, presence: true
  validates :description, presence: true, if: -> { charge_type == 'fine' }

  validate :unit_valid?

  enum charge_type: { fine: 0, common_area_fee: 1 }

  def unit_valid?
    return true if unit.owner

    errors.add(:unit, 'Não há proprietário para a unidade selecionada')
  end
end
