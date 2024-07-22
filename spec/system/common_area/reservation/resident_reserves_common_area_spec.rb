require 'rails_helper'

describe 'Resident reserves common area' do
  it 'successfully if there is no confirmed reservation on the same date' do
    common_area = create :common_area, rules: 'Não pode subir no escorregador.'
    first_resident = create :resident, :with_residence, full_name: 'Maria Pereira', condo: common_area.condo
    second_resident = create :resident

    get_data = Rails.root.join('spec/support/json/common_areas/common_area_fees.json').read
    allow(Faraday).to receive(:get).and_return(double('response', body: get_data, success?: true, status: 200))

    post_data = Rails.root.join('spec/support/json/common_areas/single_charge.json').read
    allow(Faraday).to receive(:post).and_return(double('response', body: post_data, success?: true, status: 201))

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
    expect(common_area.reservations.last.date).to eq Date.new(2024, 7, 5)
  end

  it 'fail if the connection is lost with external application' do
    common_area = create :common_area
    resident = create :resident, :with_residence, condo: common_area.condo
    allow(Faraday).to receive(:get).and_raise(Faraday::ConnectionFailed)
    allow(Faraday).to receive(:post).and_raise(Faraday::ConnectionFailed)

    travel_to '01/07/2024' do
      login_as resident, scope: :resident
      visit common_area_path common_area
      within('.table > tbody > tr:nth-child(1) > .wday-5') { accept_confirm { click_on 'Reservar' } }
    end

    expect(current_path).to eq common_area_path common_area
    expect(page).to have_content 'Conexão perdida com o servidor do PagueAluguel'

    within('.table > tbody > tr:nth-child(1) > .wday-5') do
      expect(page).not_to have_content 'Reservado por Maria Pereira'
      expect(page).to have_button 'Reservar'
      expect(page).not_to have_button 'Cancelar'
    end

    expect(Reservation.count).to eq 0
  end
end
