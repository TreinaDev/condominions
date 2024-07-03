class Condo < ApplicationRecord
  belongs_to :address
  has_many :towers, dependent: :destroy
  has_many :common_areas, dependent: :destroy

  validates :name, presence: true
  validates :registration_number, uniqueness: true

  validate :validate_cnpj

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
    if CNPJ.valid? registration_number
      unless registration_number.match %r{\A\d{2}[\.]\d{3}[\.]\d{3}[\/]\d{4}-\d{2}\z}
        errors.add(:registration_number, 'deve estar no seguinte formato: XX.XXX.XXX/XXXX-XX')
      end
    else
      errors.add(:registration_number, 'inválido')
    end
  end
end
