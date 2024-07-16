require 'rails_helper'

describe 'Resident reserves common area' do
  it 'only if authenticated' do
    common_area = create :common_area

    visit new_common_area_reservation_path common_area

    expect(current_path).to eq new_resident_session_path
  end

  it 'successfully' do
    common_area = create :common_area, rules: 'Não pode subir no escorregador.'
    resident = create :resident

    login_as resident, scope: :resident
    visit common_area_path common_area
    click_on 'Reservar'
    fill_in 'Data', with: Date.current + 1.week
    click_on 'Reservar'

    expect(page).to have_content 'Não pode subir no escorregador.'
    expect(current_path).to eq reservation_path Reservation.last
    expect(page).to have_content 'Reserva realizada com sucesso!'
    expect(page).to have_content "Data: #{I18n.l Date.current + 1.week}"
    expect(Reservation.last.resident).to eq resident
  end

  it "fail if date isn't selected" do
    common_area = create :common_area
    resident = create :resident

    login_as resident, scope: :resident
    visit new_common_area_reservation_path common_area
    fill_in 'Data', with: ''
    click_on 'Reservar'

    expect(page).to have_content 'Não foi possível realizar a reserva'
    expect(current_path).to eq new_common_area_reservation_path common_area
    expect(page).to have_content 'Data não pode ficar em branco'
    expect(Reservation.all.empty?).to be true
  end
end
