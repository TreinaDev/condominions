require 'rails_helper'

describe "Administrator sees tower's details" do
  it 'only if authenticated' do
    tower = create :tower

    visit tower_path tower

    expect(current_path).to eq new_manager_session_path
  end

  it "and sees a list of tower's floors" do
    condo = create :condo
    user = create :manager
    tower = create :tower, condo:, name: 'Torre A', floor_quantity: 3

    login_as user, scope: :manager
    visit condo_path condo
    find('#tower-1').click

    expect(current_path).to eq tower_path tower
    expect(page).to have_content 'Torre A'
    expect(page).to have_content 'Andares'
    expect(page).to have_content '1º Andar'
    expect(page).to have_content '2º Andar'
    expect(page).to have_content '3º Andar'
  end
end
