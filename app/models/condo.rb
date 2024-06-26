class Condo < ApplicationRecord
  belongs_to :address

  validates :name, :registration_number, presence: true
  validates :registration_number, uniqueness: true

  validate :validate_CNPJ

  accepts_nested_attributes_for :address

  def full_address
    address = self.address
    "#{address.public_place}, #{address.number}, #{address.neighborhood} - #{address.city}/#{address.state} - CEP: #{address.zip}"
  end

  private 

  def validate_CNPJ 
    return if CNPJ.valid? registration_number

    errors.add(:registration_number, 'inválido')
  end

end
