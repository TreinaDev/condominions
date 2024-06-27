class Floor < ApplicationRecord
  belongs_to :tower
  has_many :units, dependent: :destroy
end
