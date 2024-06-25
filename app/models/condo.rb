class Condo < ApplicationRecord
  belongs_to :address

  validates :name, :registration_number, presence: true
  validates :registration_number, uniqueness: true

  accepts_nested_attributes_for :address

  def full_address
    address = self.address
    "#{address.public_place}, #{address.number}, #{address.neighborhood} - #{address.city}/#{address.state} - CEP: #{address.zip}"
  end
end
