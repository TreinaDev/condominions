require 'rails_helper'

describe 'Manager register condo' do
  it 'and access from navbar' do
    user = create(:manager)
    login_as user, scope: :manager

    visit root_path
    within('nav') do
      click_on id: 'side-menu'
      click_on 'Criar Condominio'
    end

    within 'ol.breadcrumb' do
      expect(page).to have_content 'Home'
      expect(page).to have_content 'Cadastrar'
    end

    expect(current_path).to eq new_condo_path
    expect(page).to have_content('Cadastre um novo Condomínio:')
  end

  it 'must be authenticated as manager' do
    visit new_condo_path

    expect(current_path).to eq new_manager_session_path
  end

  it 'sucessfully' do
    manager = create(:manager)

    login_as(manager, scope: :manager)
    visit new_condo_path
    fill_in 'Nome',	with: 'Condominio Teste'
    fill_in 'CNPJ', with: '38.352.640/0001-33'
    fill_in 'Logradouro', with: 'Travessa João Edimar'
    fill_in 'Nº', with: '29'
    fill_in 'Bairro', with: 'João Eduardo II'
    fill_in 'Cidade', with: 'Rio Branco'
    select 'AC', from: 'Estado'
    fill_in 'CEP', with: '69911-520'

    click_on 'Salvar'

    expect(current_path).to eq condo_path(Condo.last)

    within 'ol.breadcrumb' do
      expect(page).to have_content 'Home'
      expect(page).to have_content 'Condomínios'
      expect(page).to have_content 'Condominio Teste'
    end
    expect(page).to have_content 'Cadastrado com sucesso'
    expect(page).to have_content 'Condominio Teste'
    expect(page).to have_content 'CNPJ: 38.352.640/0001-33'
    expect(page).to have_content 'Endereço: Travessa João Edimar, 29, João Eduardo II - Rio Branco/AC - CEP: 69911-520'
  end

  it 'with missing params' do
    manager = create(:manager)

    login_as(manager, scope: :manager)
    visit new_condo_path

    fill_in 'Nome', with: ''
    fill_in 'CNPJ', with: ''
    fill_in 'Logradouro', with: ''
    fill_in 'Nº', with: ''
    fill_in 'Bairro', with: ''
    fill_in 'Cidade', with: ''
    fill_in 'CEP', with: ''
    click_on 'Salvar'

    expect(current_path).to eq(new_condo_path)
    expect(page).to have_content 'Nome não pode ficar em branco'
    expect(page).to have_content 'CNPJ inválido'
    expect(page).to have_content 'Logradouro não pode ficar em branco'
    expect(page).to have_content 'Nº não pode ficar em branco'
    expect(page).to have_content 'Bairro não pode ficar em branco'
    expect(page).to have_content 'Cidade não pode ficar em branco'
    expect(page).to have_content 'CEP inválido'
  end
end
