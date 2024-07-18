require 'rails_helper'

describe 'User sees reservation details' do
  it 'and must be authenticated' do
    reservation = create :reservation

    visit reservation_path reservation

    expect(current_path).to eq signup_choice_path
  end

  it 'and administrators can see any reservation details from their condo' do
    condo = create :condo
    manager = create :manager
    condo.managers << manager
    common_area = create(:common_area, condo:)
    reservation = create(:reservation, common_area:)

    login_as manager, scope: :manager
    visit reservation_path reservation

    expect(current_path).to eq reservation_path reservation
    expect(page).not_to have_link 'Cancelar'
  end

  it 'and administrators cannot see reservation details from another condos' do
    condo = create :condo
    manager = create :manager, is_super: false
    common_area = create(:common_area, condo:)
    reservation = create(:reservation, common_area:)

    login_as manager, scope: :manager
    visit reservation_path reservation

    expect(current_path).to eq root_path
    expect(page).to have_content 'Você não tem permissão para fazer isso.'
  end

  it 'and residents can only see their own reservation details' do
    first_resident = create :resident
    second_resident = create :resident, email: 'second@email.com'
    reservation = create :reservation, resident: first_resident

    login_as second_resident, scope: :resident
    visit reservation_path reservation

    expect(current_path).to eq root_path
    expect(page).to have_content 'Você não tem permissão para fazer isso.'
  end
end
