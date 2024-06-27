class Address < ApplicationRecord
  STATES = %w[AC AL AP AM BA CE DF ES GO MA MS MT MG PA PB PR PE PI RJ RN RS RO RR SC SP SE TO].freeze
  has_one :condo, dependent: :destroy

  validates :public_place, :number, :neighborhood, :city, :state, presence: true
  validates :zip, format: { with: /\A\d{5}-\d{3}\z/, message: 'deve estar no seguinte formato: XXXXX-XXX' }
end
