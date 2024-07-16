class Reservation < ApplicationRecord
  belongs_to :common_area
  belongs_to :resident

  validates :date, presence: true
end
