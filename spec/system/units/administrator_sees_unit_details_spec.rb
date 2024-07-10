require 'rails_helper'

describe "Administrator sees unit's details" do
  it 'only if authenticated' do
    tower = create :tower
    floor = tower.floors.first

    visit tower_floor_unit_path(tower, floor, floor.units[1])

    expect(current_path).to eq new_manager_session_path
  end

  it "from floor's details page" do
    user = create :manager
    unit_type = build :unit_type,
                      description: 'Apartamento de 1 quarto',
                      metreage: 50.55

    tower = create :tower
    floor = tower.floors.first
    floor.units[1].update(unit_type:)

    login_as user, scope: :manager
    visit tower_floor_unit_path(tower, floor, floor.units[1])

    expect(page).to have_content 'Unidade 12'
    expect(page).to have_content 'Apartamento de 1 quarto'
    expect(page).to have_content '50.55m²'
  end
end
