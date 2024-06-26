require 'rails_helper'

describe 'Administrador cadastra o condominio a partir da página inicial' do 
  it 'Com sucesso' do 
    visit new_condo_path
    #click_on 'Cadastrar Condomínio'

    fill_in 'Nome',	with: 'Condominio Teste'
    fill_in 'CNPJ', with: '38352640000133'
    fill_in 'Logradouro', with: 'Travessa João Edimar'
    fill_in 'N°', with: '29'
    fill_in 'Bairro', with: 'João Eduardo II'
    fill_in 'Cidade', with: 'Rio Branco'
    select 'AC', from: 'Estado'
    fill_in 'CEP', with: '69911520'

    click_on 'Cadastrar'

    expect(current_path).to eq condo_path(Condo.last)
    expect(page).to have_content 'Cadastrado com sucesso'
    expect(page).to have_content 'Condominio Teste'
    expect(page).to have_content 'CNPJ: 38352640000133'
    expect(page).to have_content 'Endereço: Travessa João Edimar, 29, João Eduardo II - Rio Branco/AC - CEP: 69911520'
  end
end