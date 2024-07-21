require 'rails_helper'

RSpec.describe Reservation, type: :model do
  describe 'Cancel reservation' do
    it 'for a future day' do
      travel_to '01/07/2024' do
        reservation = build :reservation, date: '02/07/2024'

        reservation.update status: :canceled

        expect(reservation.canceled?).to be true
      end
    end

    it 'but cannot cancel for the present or past days' do
      travel_to '01/07/2024' do
        reservation = build :reservation, date: '01/07/2024'

        reservation.update status: :canceled

        expect(reservation.canceled?).to be false
      end
    end
  end

  describe '#valid' do
    it 'date must be present' do
      reservation = build :reservation, date: nil

      expect(reservation).not_to be_valid
      expect(reservation.errors).to include :date
    end

    it 'date cannot have multiple reservations' do
      common_area = create :common_area, rules: 'Não pode subir no escorregador.'
      first_resident = build :resident
      second_resident = build :resident, email: 'morador@mail.com'

      first_reservation = build :reservation, common_area:, date: Date.current + 1.week, resident: first_resident
      common_area.reservations << first_reservation

      second_reservation = build :reservation, common_area:, date: Date.current + 1.week, resident: second_resident

      expect(Reservation.all.size).to eq 1
      expect(second_reservation).not_to be_valid
      expect(second_reservation.errors.full_messages).to include "Data #{I18n.l Date.current + 1.week} " \
                                                                 'já está reservada para esta área comum'
    end

    it 'date must be current or future' do
      reservation = build :reservation, date: Date.current - 1.day

      expect(Reservation.all.empty?).to be true
      expect(reservation).not_to be_valid
      expect(reservation.errors.full_messages).to include 'Data deve ser atual ou futura'
    end
  end
end
