class Address < ApplicationRecord
  STATES = %w[AC AL AP AM BA CE DF ES GO MA MS MT MG PA PB PR PE PI RJ RN RS RO RR SC SP SE TO].freeze
  has_one :condo, dependent: :destroy

  validates :public_place, :number, :neighborhood, :city, :state, presence: true
  validate :validate_zip

  private

  def validate_zip
    if zip && zip.size >= 8
      errors.add(:zip, 'deve estar no seguinte formato: XXXXX-XXX') unless zip.match(/\A\d{5}-\d{3}\z/)
    else
      errors.add(:zip, 'inválido')
    end
  end
end
