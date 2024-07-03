require 'rails_helper'

describe "Administrator sees tower's details" do
  it "and sees a list of tower's floors" do
    tower = build :tower, name: 'Torre A', floor_quantity: 3
    tower.generate_floors

    visit tower_path(tower)

    within 'ol.breadcrumb' do
      expect(page).to have_content 'Home'
      expect(page).to have_content 'Condomínios'
      expect(page).to have_content 'Condominio Residencial Paineiras'
      expect(page).to have_content 'Torres'
      expect(page).to have_content 'Torre A'
    end
    expect(page).to have_content 'Torre A'
    expect(page).to have_content 'Andares'
    expect(page).to have_content '1º Andar'
    expect(page).to have_content '2º Andar'
    expect(page).to have_content '3º Andar'
  end
end
