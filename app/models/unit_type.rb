class UnitType < ApplicationRecord
  validates :description, :metreage, presence: true
end
