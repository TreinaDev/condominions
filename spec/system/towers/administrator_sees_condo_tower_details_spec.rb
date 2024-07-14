require 'rails_helper'

describe "Administrator sees tower's details" do
  it 'only if authenticated' do
    tower = create :tower

    visit tower_path tower

    expect(current_path).to eq new_manager_session_path
  end

  it "and a resident can't see tower details" do
    resident = create :resident
    tower = create :tower

    login_as resident, scope: :resident
    visit tower_path tower

    expect(current_path).to eq root_path
    expect(page).to have_content 'Você não tem permissão para acessar essa página'
  end

  it "and sees a list of tower's floors" do
    condo = create :condo
    condo_manager = create :manager, is_super: false
    tower = create :tower, condo:, name: 'Torre A', floor_quantity: 3
    condo.managers << condo_manager

    login_as condo_manager, scope: :manager
    visit condo_path condo
    click_on 'Lista de Torres'
    find('#tower-1').click

    expect(current_path).to eq tower_path tower
    expect(page).to have_content 'Torre A'
    expect(page).to have_content 'Andares'
    expect(page).to have_content '1º Andar'
    expect(page).to have_content '2º Andar'
    expect(page).to have_content '3º Andar'
  end
end
