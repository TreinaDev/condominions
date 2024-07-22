require 'rails_helper'

describe 'Resident cancel common area reservation' do
  it 'from calendar' do
    common_area = create :common_area
    resident = create :resident, :with_residence, condo: common_area.condo

    patch_data = Rails.root.join('spec/support/json/common_areas/single_charge_cancelation.json').read
    allow(Faraday).to receive(:patch).and_return(double('response', body: patch_data, success?: true, status: 200))

    travel_to '01/07/2024' do
      reservation = create :reservation,
                           common_area:,
                           resident:,
                           date: '05/07/2024',
                           single_charge_id: 1,
                           status: :confirmed

      login_as resident, scope: :resident
      visit common_area_path common_area

      within('.table > tbody > tr:nth-child(1) > .wday-5') do
        accept_confirm { click_on 'Cancelar' }
        reservation.reload

        expect(page).not_to have_content 'Reservado'
        expect(page).not_to have_button 'Cancelar'
      end

      expect(current_path).to eq common_area_path common_area
      expect(page).to have_content 'Reserva cancelada com sucesso'
      expect(reservation.canceled?).to be true
    end
  end

  it 'and does not see a button to cancel a reservation for days that have already passed' do
    common_area = create :common_area
    resident = create :resident, :with_residence, condo: common_area.condo

    travel_to '03/07/2024' do
      create :reservation, common_area:, resident:, date: '03/07/2024', single_charge_id: 1, status: :confirmed
    end

    travel_to '05/07/2024' do
      login_as resident, scope: :resident
      visit common_area_path common_area

      within('.table > tbody > tr:nth-child(1) > .wday-3') do
        expect(page).to have_content 'Reservado'
        expect(page).not_to have_button 'Cancelar'
      end
    end
  end

  it 'fail if the connection is lost with external application' do
    common_area = create :common_area
    resident = create :resident, :with_residence, condo: common_area.condo

    travel_to '01/07/2024' do
      reservation = create :reservation,
                           common_area:,
                           resident:,
                           date: '05/07/2024',
                           single_charge_id: 1,
                           status: :confirmed

      login_as resident, scope: :resident
      visit common_area_path common_area

      within('.table > tbody > tr:nth-child(1) > .wday-5') do
        accept_confirm { click_on 'Cancelar' }
        reservation.reload

        expect(page).to have_content 'Reservado'
        expect(page).to have_button 'Cancelar'
        expect(page).not_to have_button 'Reservar'
      end

      expect(page).to have_content 'Conexão perdida com o servidor do PagueAluguel'
      expect(page).not_to have_content 'Reserva cancelada com sucesso'
      expect(current_path).to eq common_area_path common_area
      expect(reservation.canceled?).to be false
    end
  end
end
