class Condo < ApplicationRecord
  belongs_to :address

  validates :name, presence: true
  validates :registration_number, uniqueness: true

  validate :validate_cnpj
  validates :registration_number, format: {
    with: %r{\A\d{2}[\.]\d{3}[\.]\d{3}[\/]\d{4}-\d{2}\z},
    message: 'deve estar no seguinte formato: XX.XXX.XXX/XXXX-XX' }

  accepts_nested_attributes_for :address

  def full_address
    address = self.address
    <<~HEREDOC.strip
      #{address.public_place}, #{address.number}, #{address.neighborhood} - \
      #{address.city}/#{address.state} - CEP: #{address.zip}
    HEREDOC
  end

  private

  def validate_cnpj
    return if CNPJ.valid? registration_number

    errors.add(:registration_number, 'inválido')
  end
end
