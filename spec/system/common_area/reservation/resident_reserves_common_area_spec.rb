require 'rails_helper'

describe 'Resident reserves common area' do
  it 'successfully if there is no confirmed reservation on the same date' do
    common_area = create :common_area, rules: 'Não pode subir no escorregador.'
    first_resident = create :resident, :with_residence, full_name: 'Maria Pereira', condo: common_area.condo
    second_resident = create :resident

    travel_to '01/07/2024' do
      create :reservation,
             common_area:,
             resident: second_resident,
             date: '05/07/2024',
             status: :canceled

      login_as first_resident, scope: :resident
      visit common_area_path common_area
      within('.table > tbody > tr:nth-child(1) > .wday-5') { accept_confirm { click_on 'Reservar' } }
    end

    expect(current_path).to eq common_area_path common_area
    expect(page).to have_content 'Reserva realizada com sucesso!'

    within('.table > tbody > tr:nth-child(1) > .wday-5') do
      expect(page).to have_content 'Reservado por Maria Pereira'
      expect(page).not_to have_button 'Reservar'
      expect(page).to have_button 'Cancelar'
    end

    expect(Reservation.last.resident).to eq first_resident
  end
end
