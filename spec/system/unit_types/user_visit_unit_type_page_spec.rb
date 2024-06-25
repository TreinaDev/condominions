require 'rails_helper'

describe 'User register new unit type' do
  it 'sucessfully' do
    visit new_unit_type_path

    fill_in 'Descrição',	with: 'Apartamento de 2 quartos'
    fill_in 'Metragem',	with: '50'
    click_on 'Cadastrar'

    expect(page).to have_content('Tipo de unidade cadastrado com sucesso')
    expect(current_path).to eq unit_type_path(UnitType.last)
    expect(page).to have_content('Descrição: Apartamento de 2 quartos')
    expect(page).to have_content('Metragem: 50.0m²')
  end

  it 'with missing parameters' do
    visit new_unit_type_path

    click_on 'Cadastrar'

    expect(page).to have_content('Erro ao cadastrar tipo de unidade')
    expect(page).to have_content('Descrição não pode ficar em branco')
    expect(page).to have_content('Metragem não pode ficar em branco')
  end

  xit 'from condo page' do
  end
end
