class Reservation < ApplicationRecord
  belongs_to :common_area
  belongs_to :resident

  enum status: { confirmed: 0, canceled: 3 }

  validates :date, presence: true
  validate :check_availability, :date_must_be_actual_or_future, on: :create

  def generate_single_charge
    url = "#{Rails.configuration.api['base_url']}/single_charges/"
    Faraday.post(url, single_charge_json, 'Content-Type' => 'application/json')
  end

  def single_charge_json
    { single_charge: {
      description: nil,
      value_cents: common_area.fee,
      charge_type: 'common_area_fee',
      issue_date: date,
      condo_id: common_area.condo.id,
      common_area_id: common_area.id,
      unit_id: resident.residence.id
    } }.to_json
  end

  def check_availability
    common_area.reservations.confirmed.each do |reservation|
      errors.add(:date, "#{I18n.l date} já está reservada para esta área comum") if reservation[:date] == date
    end
  end

  def date_must_be_actual_or_future
    errors.add(:date, 'deve ser atual ou futura') if date&.past?
  end

  def status=(new_status)
    return if new_status == :canceled && Time.zone.today >= date

    super
  end

  def start_time
    date
  end
end
