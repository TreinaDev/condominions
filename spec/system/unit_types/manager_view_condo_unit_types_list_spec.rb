require 'rails_helper'

describe "Manager view condo unit type's list" do
  it 'and only sees the list of unit types that belong to the condo' do
    manager = create :manager
    first_condo = create :condo, name: 'Residencial on Rails'
    second_condo = create :condo
    create :unit_type, description: 'Apartamento com 1 quarto', condo: first_condo
    create :unit_type, description: 'Apartamento com 2 quartos', condo: first_condo
    create :unit_type, description: 'Apartamento com 3 quartos', condo: first_condo
    create :unit_type, description: 'Duplex', condo: second_condo

    login_as manager, scope: :manager
    visit root_path
    within('#condos-list') { click_on 'Residencial on Rails' }
    click_on 'Lista de Tipos de Unidade'

    within('#unit-types') do
      expect(page).to have_content 'Apartamento com 1 quarto'
      expect(page).to have_content 'Apartamento com 2 quartos'
      expect(page).to have_content 'Apartamento com 3 quartos'
      expect(page).not_to have_content 'Duplex'
    end
  end

  it 'and resident can´t see list of unit types' do
    condo = create :condo
    create :unit_type, condo:, description: 'Apartamento com 1 quarto'
    resident = create :resident

    login_as resident, scope: :resident
    visit condo_path condo

    expect(page).not_to have_content 'Lista de Tipos de Unidades'
    expect(page).not_to have_content 'Apartamento com 1 quarto'
  end

  it 'and sees a message if there are no unit types on condo' do
    manager = create :manager
    condo = create :condo

    login_as manager, scope: :manager
    visit condo_path condo
    click_on 'Lista de Tipos de Unidade'

    expect(page).to have_content 'Não existem tipos de unidade para esse condomínio'
  end
end
