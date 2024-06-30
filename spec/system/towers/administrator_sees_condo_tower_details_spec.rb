require 'rails_helper'

describe "Administrator sees tower's details" do
  it "and sees a list of tower's floors" do
    tower = build :tower, name: 'Torre A', floor_quantity: 3
    tower.generate_floors

    visit tower_path(tower)

    expect(page).to have_content 'Torre A'
    expect(page).to have_content 'Andares'
    expect(page).to have_content '1º Andar'
    expect(page).to have_content '2º Andar'
    expect(page).to have_content '3º Andar'
  end
end
