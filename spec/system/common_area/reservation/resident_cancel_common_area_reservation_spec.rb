require 'rails_helper'

describe 'Resident cancel common area reservation' do
  it 'from the reservation details page' do
    resident = create :resident
    common_area = create :common_area

    travel_to '01/07/2024' do
      reservation = create :reservation,
                           common_area:,
                           resident:,
                           date: '05/07/2024',
                           status: :confirmed

      login_as resident, scope: :resident
      visit common_area_path common_area

      within('.table > tbody > tr:nth-child(1) > .wday-5') do
        click_on 'Cancelar'
        reservation.reload

        expect(page).not_to have_content 'Reservado'
        expect(page).not_to have_button 'Cancelar'
      end

      expect(current_path).to eq common_area_path common_area
      expect(page).to have_content 'Reserva cancelada com sucesso'
      expect(reservation.canceled?).to be true
    end
  end
end
