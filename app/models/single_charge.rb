class SingleCharge < ApplicationRecord
  belongs_to :condo
  belongs_to :unit
  belongs_to :common_area, optional: true

  enum charge_type: { fine: 0, common_area_fee: 1 }
end
