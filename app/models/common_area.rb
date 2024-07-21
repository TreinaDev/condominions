class CommonArea < ApplicationRecord
  include CurrencyHelper

  belongs_to :condo
  has_many :reservations, dependent: :destroy

  validates :name, :description, :max_occupancy, presence: true
  validates :max_occupancy, numericality: { greater_than: 0 }

  def access_allowed?(resident)
    condo.residents.include?(resident)
  end

  def formatted_fee
    currency = integer_to_brl(fee)
    currency.nil? ? 'Não informada' : currency
  end

  private

  def fee
    url = "#{Rails.configuration.api['base_url']}/condos/#{condo.id}/common_area_fees"

    common_area_fees = JSON.parse(Faraday.get(url).body)
    this_fee = common_area_fees.find { |fee| fee['common_area_id'] == id }
    this_fee.present? ? this_fee['value_cents'] : nil
  end
end
