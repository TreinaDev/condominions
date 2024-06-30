require 'rails_helper'

describe "Administrator sees floor's details" do
  it "and sees a list of floor's apartments" do
    first_unit_type =  create :unit_type, description: 'Apartamento de 1 quarto', metreage: 50.55
    second_unit_type = create :unit_type, description: 'Apartamento de 2 quartos', metreage: 80.75
    tower = create :tower, units_per_floor: 5, floor_quantity: 3
    tower.generate_floors
    floor = tower.floors[1]
    floor.generate_units

    floor.units[0].update unit_type: second_unit_type
    floor.units[1].update unit_type: first_unit_type
    floor.units[2].update unit_type: second_unit_type
    floor.units[3].update unit_type: first_unit_type
    floor.units[4].update unit_type: second_unit_type

    visit tower_path tower
    click_on '2º Andar'

    expect(current_path).to eq tower_floor_path(tower, floor)
    expect(page).to have_content 'Torre A'
    expect(page).to have_content '2º Andar'

    within '#unit-type-1' do
      expect(page).to have_content 'Apartamento de 1 quarto'
      expect(page).to have_content 'Unidade 22'
      expect(page).to have_content 'Unidade 24'
    end

    within '#unit-type-2' do
      expect(page).to have_content 'Apartamento de 2 quartos'
      expect(page).to have_content 'Unidade 21'
      expect(page).to have_content 'Unidade 23'
      expect(page).to have_content 'Unidade 25'
    end
  end
end
