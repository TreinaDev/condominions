require 'rails_helper'

describe 'Reservation' do
  context 'POST /reservations' do
    it 'must be authenticated as resident to make a reservation' do
      common_area = create :common_area

      post common_area_reservations_path common_area, params: { reservation: { date: I18n.l(Date.current + 1.week) } }

      expect(response).to redirect_to new_resident_session_path
      expect(flash[:alert]).to eq 'Para continuar, faça login ou registre-se.'
      expect(Reservation.all.empty?).to be true
    end

    it 'and administrator cannot make a reservation' do
      common_area = create :common_area
      manager = build :manager

      login_as manager, scope: :manager
      post common_area_reservations_path common_area, params: { reservation: { date: I18n.l(Date.current + 1.week) } }

      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq 'Você não tem permissão para fazer isso.'
      expect(Reservation.all.empty?).to be true
    end

    it 'and resident must live at related condo of the common area' do
      first_condo = create :condo
      first_resident = create :resident, :with_residence, condo: first_condo

      second_condo = create :condo
      common_area = create :common_area, condo: second_condo

      login_as first_resident, scope: :resident
      post common_area_reservations_path common_area, params: { reservation: { date: I18n.l(Date.current + 1.week) } }

      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq 'Você não tem permissão para fazer isso.'
      expect(Reservation.all.empty?).to be true
    end
  end

  context 'POST /canceled_reservation' do
    it 'must be authenticated as resident to cancel a reservation' do
      reservation = create :reservation

      post canceled_reservation_path reservation

      expect(response).to redirect_to new_resident_session_path
      expect(flash[:alert]).to eq 'Para continuar, faça login ou registre-se.'
      expect(reservation.confirmed?).to be true
    end

    it 'and residents can only cancel their own reservations' do
      first_resident = create :resident
      second_resident = create :resident, email: 'second@email.com'
      reservation = create(:reservation, resident: first_resident)

      login_as second_resident, scope: :resident
      post canceled_reservation_path reservation

      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq 'Você não tem permissão para fazer isso.'
      expect(reservation.confirmed?).to be true
    end

    it 'and administrator cannot cancel a reservation' do
      reservation = create :reservation
      manager = build :manager

      login_as manager, scope: :manager
      post canceled_reservation_path reservation

      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq 'Você não tem permissão para fazer isso.'
      expect(reservation.confirmed?).to be true
    end

    it 'and cannot cancel when the reservation date is in the past' do
      common_area = create :common_area
      resident = create :resident, :with_residence, condo: common_area.condo

      travel_to '01/07/2024' do
        reservation = create :reservation, resident:, common_area:, date: '01/07/2024'

        login_as resident, scope: :resident
        post canceled_reservation_path reservation

        expect(response).to redirect_to common_area
        expect(flash[:alert]).to eq 'Não é possível cancelar reservas passadas ou do dia atual.'
        expect(reservation.canceled?).to be false
      end
    end
  end
end
