require 'rails_helper'

describe "Administrator registers condo's tower" do
  it 'only if authenticated' do
    condo = create(:condo)

    visit new_condo_tower_path condo

    expect(current_path).to eq new_manager_session_path
  end

  it 'and access from navbar' do
    user = create(:manager)
    condo = create(:condo, name: 'Condomínio dos rubinhos')
    login_as user, scope: :manager

    visit root_path
    within 'nav' do
      click_on id: 'side-menu'
      click_on 'Criar Torre'
    end
    within '#condoSelectPopupForTowers' do
      click_on 'Condomínio dos rubinhos'
    end

    expect(current_path).to eq new_condo_tower_path condo
    expect(page).to have_content('Cadastrar Torre')
  end

  it 'successfully' do
    user = create(:manager)
    condo = create(:condo)

    login_as user, scope: :manager
    visit new_condo_tower_path condo
    fill_in 'Nome', with: 'Torre A'
    fill_in 'Quantidade de Andares', with: 5
    fill_in 'Apartamentos por Andar', with: 3
    click_on 'Criar Torre'

    expect(page).to have_content 'Torre cadastrada com sucesso!'
    expect(page).to have_content 'Atualizar Pavimento Tipo'
    expect(page).to have_content 'Torre A'
    expect(Tower.last.floors.count).to eq 5
    expect(Tower.last.floors.last.units.count).to eq 3
  end

  it 'and only sees associated condos' do
    condo_manager = create :manager, is_super: false
    first_condo = create :condo, name: 'Condomínio dos rubinhos'
    second_condo = create :condo, name: 'Condomínio correto'
    second_condo.managers << condo_manager

    login_as condo_manager, scope: :manager
    visit root_path
    within 'nav' do
      click_on id: 'side-menu'
      click_on 'Criar Torre'
    end

    within '#condoSelectPopupForTowers' do
      expect(page).not_to have_link first_condo.name
      expect(page).to have_link second_condo.name
    end
  end

  it 'and fails if there are blank fields' do
    user = create(:manager)
    condo = create(:condo)

    login_as user, scope: :manager
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
