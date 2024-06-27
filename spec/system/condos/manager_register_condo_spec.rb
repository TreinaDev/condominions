require 'rails_helper'

describe 'Manager register condo' do
  it 'sucessfully' do
    visit new_condo_path
    # click_on 'Cadastrar Condomínio'
    fill_in 'Nome',	with: 'Condominio Teste'
    fill_in 'CNPJ', with: '38352640000133'
    fill_in 'Logradouro', with: 'Travessa João Edimar'
    fill_in 'Nº', with: '29'
    fill_in 'Bairro', with: 'João Eduardo II'
    fill_in 'Cidade', with: 'Rio Branco'
    select 'AC', from: 'Estado'
    fill_in 'CEP', with: '69911520'

    click_on 'Salvar'

    expect(current_path).to eq condo_path(Condo.last)
    expect(page).to have_content 'Cadastrado com sucesso'
    expect(page).to have_content 'Condominio Teste'
    expect(page).to have_content 'CNPJ: 38.352.640/0001-33'
    expect(page).to have_content 'Endereço: Travessa João Edimar, 29, João Eduardo II - Rio Branco/AC - CEP: 69911-520'
  end

  it 'with missing params' do
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
