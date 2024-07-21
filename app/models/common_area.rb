class CommonArea < ApplicationRecord
  belongs_to :condo
  has_many :reservations, dependent: :destroy

  validates :name, :description, :max_occupancy, presence: true
  validates :max_occupancy, numericality: { greater_than: 0 }

  def access_allowed?(resident)
    condo.residents.include?(resident)
  end

  def tax
    common_area_fee = JSON.parse(Faraday.get("#{Rails.configuration.api['base_url']}/common_area_fees/#{id}").body)
    common_area_fee['errors'].present? ? 'Não identificada' : common_area_fee['value_cents']
  end
end
