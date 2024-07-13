require 'rails_helper'

describe 'Manager sees unit type details' do
  it 'only if authenticated' do
    unit_type = create :unit_type

    visit unit_type_path unit_type

    expect(current_path).to eq new_manager_session_path
  end

  it "and a resident can't see unit type details" do
    resident = create :resident
    unit_type = create :unit_type

    login_as resident, scope: :resident
    visit unit_type_path unit_type

    expect(current_path).to eq root_path
    expect(page).to have_content 'Você não tem permissão para acessar essa página'
  end

  it 'successfully' do
    condo = create :condo
    user = create :manager
    unit_type = create :unit_type, condo:, description: 'Apartamento de 1 quarto', metreage: 50, fraction: 3

    login_as user, scope: :manager
    visit condo_path condo
    click_on 'Lista de Tipos de Unidade'
    find('#unit-type-1').click

    expect(current_path).to eq unit_type_path unit_type
    expect(page).to have_content 'Descrição: Apartamento de 1 quarto'
    expect(page).to have_content 'Metragem: 50.0m²'
    expect(page).to have_content 'Fração Ideal: 3.0%'
  end
end
