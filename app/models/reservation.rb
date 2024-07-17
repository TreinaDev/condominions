class Reservation < ApplicationRecord
  belongs_to :common_area
  belongs_to :resident

  validates :date, presence: true
  validate :check_availability, :date_must_be_actual_or_future

  def check_availability
    common_area.reservations.each do |reservation|
      errors.add(:date, "#{I18n.l date} já está reservada para esta área comum") if reservation[:date] == date
    end
  end

  def date_must_be_actual_or_future
    errors.add(:date, 'deve ser atual ou futura') if date&.past?
  end
end
