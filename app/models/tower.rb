class Tower < ApplicationRecord
  belongs_to :condo
  has_many :floors
end
