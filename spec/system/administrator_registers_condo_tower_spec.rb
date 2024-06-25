require 'rails-helper'

describe 'Administrator registers condo tower' do
  it 'successfully' do
    address = Address
      .create! public_place: 'Rua dos Rubis',
               number: '120',
               neighborhood: 'Jardim dos Rubis',
               city: 'Xique-Xique',
               state: 'BA',
               zip: '42800000'

    condo = condo
      .create! name: 'Condomínio dos Rubis',
               registration_number: '82909116000102',
               address: address

    visit new_condo_tower_path condo

    fill_in 'Nome', with: 'Torre A'
    fill_in 'Quantidade de Andares', with: 5
    fill_in 'Apartamentos por Andar', with: 3
    click_on 'Cadastrar Torre'

    expect(page).to have_content 'Torre A'
    expect(page).to have_content 'Quantidade de Andares: 5'
    expect(page).to have_content 'Apartamentos por Andar: 3'
    expect(Tower.last.floors.count).to eq 5
    expect(Tower.last.floors.first.units.count).to eq 3
  end
end
