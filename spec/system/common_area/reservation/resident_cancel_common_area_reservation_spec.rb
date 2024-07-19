require 'rails_helper'

describe 'Resident cancel common area reservation' do
  it 'from the reservation details page' do
    resident = create :resident, :with_residence
    reservation = create :reservation, resident:, status: :confirmed

    login_as resident, scope: :resident
    visit reservation_path reservation
    accept_confirm { click_on 'Cancelar' }
    reservation.reload

    expect(current_path).to eq reservation_path reservation
    expect(page).to have_content 'Reserva cancelada com sucesso'
    expect(page).to have_content 'Status: Cancelado'
    expect(page).not_to have_button 'Cancelar'
    expect(reservation.canceled?).to be true
  end
end
