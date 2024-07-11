require 'rails_helper'

describe 'Manager view list of common areas' do
  it 'and only sees the list of common areas that belongs to the condo' do
    manager = create :manager
    first_condo = create :condo, name: 'Residencial on Rails'
    second_condo = create :condo
    create :common_area, name: 'Churrasqueira', condo: first_condo
    create :common_area, name: 'Parquinho', condo: first_condo
    create :common_area, name: 'Academia', condo: first_condo
    create :common_area, name: 'Salão de Festas', condo: second_condo

    login_as manager, scope: :manager
    visit root_path
    within('#condos-list') { click_on 'Residencial on Rails' }

    within('#common-areas') do
      expect(page).to have_content 'Churrasqueira'
      expect(page).to have_content 'Parquinho'
      expect(page).to have_content 'Academia'
      expect(page).not_to have_content 'Salão de Festas'
    end
  end

  it 'and resident can see the list too' do
    resident = create :resident
    condo = create :condo
    create :common_area, condo:, name: 'Churrasqueira'

    login_as resident, scope: :resident
    visit condo_path condo

    within('#common-areas') { expect(page).to have_content 'Churrasqueira' }
  end
end
