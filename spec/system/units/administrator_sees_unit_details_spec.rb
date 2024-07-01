require 'rails_helper'

describe "Administrator sees unit's details" do
  it "from floor's details page" do
    unit_type = build :unit_type,
                      description: 'Apartamento de 1 quarto',
                      metreage: 50.55

    tower = create :tower
    tower.generate_floors
    floor = tower.floors.first
    floor.generate_units
    floor.units[1].update(unit_type:)

    visit tower_floor_unit_path(tower, floor, floor.units[1])

    expect(page).to have_content 'Unidade 12'
    expect(page).to have_content 'Apartamento de 1 quarto'
    expect(page).to have_content '50.55m²'
  end
end
