class Address < ApplicationRecord
  has_one :condo

  validates :public_place, :number, :neighborhood, :city, :state, :zip, presence: true
end
