class Condo < ApplicationRecord
  belongs_to :address
  has_many :towers, dependent: :destroy
end
