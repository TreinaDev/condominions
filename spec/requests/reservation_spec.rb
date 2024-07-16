require 'rails_helper'

describe 'Reservation' do
  context 'POST /reservations' do
    it 'must be authenticated as resident to make a reservation' do
      common_area = create :common_area
      resident = build :resident

      post common_area_reservations_path common_area,
           params: { reservation: { date: I18n.l(Date.current + 1.week),
                                    resident_id: resident.id } }

      expect(response).to redirect_to new_resident_session_path
      expect(flash[:alert]).to eq 'Para continuar, faça login ou registre-se.'
      expect(Reservation.all.empty?).to be true
    end

    it 'and administrator cannot make a reservation' do
      common_area = create :common_area
      manager = build :manager

      login_as manager, scope: :manager
      post common_area_reservations_path common_area,
           params: { reservation: { date: I18n.l(Date.current + 1.week),
                                    resident_id: manager.id } }

      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq 'Para continuar, faça login ou registre-se.'
      expect(Reservation.all.empty?).to be true
    end
  end
end
