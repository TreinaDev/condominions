class Floor < ApplicationRecord
  belongs_to :tower
  has_many :units
end
