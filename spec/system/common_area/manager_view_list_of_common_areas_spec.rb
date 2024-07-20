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
    click_on 'Lista de Áreas Comuns'

    within('#common-areas') do
      expect(page).to have_content 'Churrasqueira'
      expect(page).to have_content 'Parquinho'
      expect(page).to have_content 'Academia'
      expect(page).not_to have_content 'Salão de Festas'
    end
  end

  it 'and resident can see the list too' do
    condo = create :condo
    create :common_area, condo:, name: 'Churrasqueira'
    resident = create(:resident, :with_residence, condo:)

    login_as resident, scope: :resident
    visit condo_path condo
    click_on 'Lista de Áreas Comuns'

    within('#common-areas') { expect(page).to have_content 'Churrasqueira' }
  end

  it 'and sees a message if there are no common areas on condo' do
    manager = create :manager
    condo = create :condo

    login_as manager, scope: :manager
    visit condo_path condo
    click_on 'Lista de Áreas Comuns'

    expect(page).to have_content 'Não existem áreas comuns para esse condomínio'
  end
end
