class Condo < ApplicationRecord
  belongs_to :address
  has_many :towers, dependent: :destroy
  has_many :common_areas, dependent: :destroy
end
