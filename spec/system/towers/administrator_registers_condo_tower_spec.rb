require 'rails_helper'

describe "Administrator registers condo's tower" do
  it 'successfully' do
    condo = create(:condo)

    visit new_condo_tower_path condo

    fill_in 'Nome', with: 'Torre A'
    fill_in 'Quantidade de Andares', with: 5
    fill_in 'Apartamentos por Andar', with: 3
    click_on 'Criar Torre'

    expect(page).to have_content 'Torre cadastrada com sucesso!'
    expect(page).to have_content 'Cadastrar Pavimento Tipo'
    expect(page).to have_content 'Torre A'
    expect(Tower.last.floors.count).to eq 5
    expect(Tower.last.floors.last.units.count).to eq 3
  end

  it 'and fails if there are blank fields' do
    condo = create(:condo)

    visit new_condo_tower_path condo

    fill_in 'Nome', with: ''
    fill_in 'Quantidade de Andares', with: ''
    fill_in 'Apartamentos por Andar', with: ''
    click_on 'Criar Torre'

    expect(page).to have_content 'Não foi possível cadastrar a torre'
    expect(page).to have_content 'Nome não pode ficar em branco'
    expect(page).to have_content 'Quantidade de Andares não pode ficar em branco'
    expect(page).to have_content 'Apartamentos por Andar não pode ficar em branco'
    expect(page).to have_content 'Quantidade de Andares não é um número'
    expect(page).to have_content 'Apartamentos por Andar não é um número'
    expect(Tower.all.empty?).to be true
  end
end
