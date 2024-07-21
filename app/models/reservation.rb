class Reservation < ApplicationRecord
  belongs_to :common_area
  belongs_to :resident

  enum status: { confirmed: 0, canceled: 3 }

  validates :date, presence: true
  validate :check_availability, :date_must_be_actual_or_future, on: :create

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
