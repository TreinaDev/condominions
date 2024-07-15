require 'rails_helper'

describe 'User sees breadcrumb' do
  it 'from the floor details page' do
    manager = create :manager
    first_unit_type =  create :unit_type,
                              description: 'Apartamento de 1 quarto',
                              metreage: 50.55

    second_unit_type = create :unit_type,
                              description: 'Apartamento de 2 quartos',
                              metreage: 80.75

    condo = create :condo, name: 'Condominio Residencial Paineiras'
    tower = create(:tower, name: 'Torre A', units_per_floor: 5, floor_quantity: 3, condo:)
    floor = tower.floors[1]

    floor.units[0].update unit_type: second_unit_type
    floor.units[1].update unit_type: first_unit_type
    floor.units[2].update unit_type: second_unit_type
    floor.units[3].update unit_type: first_unit_type
    floor.units[4].update unit_type: second_unit_type

    login_as(manager, scope: :manager)
    visit tower_floor_path(tower, floor)

    within 'ol.breadcrumb' do
      expect(page).to have_link('Home', href: '/')
      expect(page).to have_link('Condominio Residencial Paineiras', href: "/condos/#{condo.id}")
      expect(page).to have_link('Torre A', href: "/towers/#{tower.id}")
      expect(page).to have_content '2º Andar'
    end
  end

  it 'from the condo register page' do
    manager = create :manager

    login_as(manager, scope: :manager)
    visit new_condo_path

    within 'ol.breadcrumb' do
      expect(page).to have_link('Home', href: '/')
      expect(page).to have_content 'Cadastrar Condomínio'
    end
  end

  it 'except on the choice sign up page' do
    visit root_path

    expect(page).not_to have_css 'ol.breadcrumb'
  end
end
