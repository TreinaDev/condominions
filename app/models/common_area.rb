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
    return fee if fee == 'Não encontrada'

    integer_to_brl(fee) || 'Não informada'
  end

  def fee
    url = "#{Rails.configuration.api['base_url']}/condos/#{condo.id}/common_area_fees"
    response = Faraday.get(url)

    common_area_fees = JSON.parse(response.body)
    this_fee = common_area_fees.find { |fee| fee['common_area_id'] == id }
    this_fee ? this_fee['value_cents'] : nil
  rescue Faraday::ConnectionFailed
    'Não encontrada'
  end
end
