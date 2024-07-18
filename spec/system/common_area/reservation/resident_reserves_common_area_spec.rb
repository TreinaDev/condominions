require 'rails_helper'

describe 'Resident reserves common area' do
  it 'only if authenticated' do
    common_area = create :common_area

    visit new_common_area_reservation_path common_area

    expect(current_path).to eq new_resident_session_path
  end

  it 'and does not see reserve button if is a manager' do
    common_area = create :common_area
    manager = create :manager

    login_as manager, scope: :manager
    visit new_common_area_reservation_path common_area

    expect(page).not_to have_link 'Reservar'
  end

  it "only if has a residence at common area's condo" do
    first_condo = create :condo
    first_resident = create :resident, :with_residence, condo: first_condo

    second_condo = create :condo
    common_area = create :common_area, condo: second_condo

    login_as first_resident, scope: :resident
    visit new_common_area_reservation_path common_area

    expect(current_path).to eq root_path
    expect(page).to have_content 'Você não tem permissão para fazer isso'
  end

  it 'successfully if there is no confirmed reservation on the same date' do
    common_area = create :common_area, rules: 'Não pode subir no escorregador.'
    first_resident = create :resident, :with_residence, condo: common_area.condo
    second_resident = create :resident

    create :reservation,
           common_area:,
           resident: second_resident,
           date: Date.current + 1.week,
           status: :canceled

    login_as first_resident, scope: :resident
    visit common_area_path common_area
    click_on 'Reservar'
    fill_in 'Data', with: Date.current + 1.week
    click_on 'Reservar'

    expect(current_path).to eq reservation_path Reservation.last
    expect(page).to have_content 'Reserva realizada com sucesso!'
    expect(page).to have_content "Data: #{I18n.l Date.current + 1.week}"
    expect(page).to have_content 'Status: Confirmado'
    expect(page).to have_content 'Não pode subir no escorregador'
    expect(Reservation.last.resident).to eq first_resident
  end

  it "fail if date isn't selected" do
    common_area = create :common_area
    resident = create :resident, :with_residence, condo: common_area.condo

    login_as resident, scope: :resident
    visit new_common_area_reservation_path common_area
    fill_in 'Data', with: ''
    click_on 'Reservar'

    expect(current_path).to eq new_common_area_reservation_path common_area
    expect(page).to have_content 'Não foi possível realizar a reserva'
    expect(page).to have_content 'Data não pode ficar em branco'
    expect(Reservation.all.empty?).to be true
  end

  it 'fail if the date already has a reservation confirmed' do
    common_area = create :common_area, rules: 'Não pode subir no escorregador.'
    first_resident = create :resident
    second_resident = create :resident, :with_residence, condo: common_area.condo
    create :reservation, common_area:, date: Date.current + 1.week, resident: first_resident, status: :confirmed

    login_as second_resident, scope: :resident
    visit new_common_area_reservation_path common_area
    fill_in 'Data', with: Date.current + 1.week
    click_on 'Reservar'

    expect(current_path).to eq new_common_area_reservation_path common_area
    expect(page).to have_content 'Não foi possível realizar a reserva'
    expect(page).to have_content "Data #{I18n.l Date.current + 1.week} já está reservada para esta área comum"
    expect(Reservation.all.size).to eq 1
  end
end
