require 'rails_helper'

describe 'Administrador edita o condominio a partir do condominio' do
  it 'com sucesso' do 
    condo = create(:condo)

    visit condo_path(condo)

    click_on 'Editar'

    fill_in 'Nome',	with: 'Condominio Editado'
    fill_in 'CNPJ', with: '34474564000188'
    fill_in 'Logradouro', with: 'Rua ST'
    fill_in 'Nº', with: '12'
    fill_in 'Bairro', with: 'Santa Terezinha'
    fill_in 'Cidade', with: 'Brusque'
    select 'SC', from: 'Estado'
    fill_in 'CEP', with: '88352272'
    click_on 'Salvar'

    expect(current_path).to eq condo_path(condo)
    expect(page).to have_content 'Editado com sucesso'
    expect(page).to have_content 'Condominio Editado'
    expect(page).to have_content 'CNPJ: 34474564000188'
    expect(page).to have_content 'Endereço: Rua ST, 12, Santa Terezinha - Brusque/SC - CEP: 88352272'
  end

  it 'Com dados incompletos' do
    condo = create(:condo)

    visit condo_path(condo)
    click_on 'Editar'

    fill_in 'CNPJ', with: ''
    fill_in 'Cidade', with: ''
    fill_in 'CEP', with: ''
    click_on 'Salvar'

    expect(current_path).to eq edit_condo_path(condo)
    expect(page).to have_content 'CNPJ não pode ficar em branco'
    expect(page).to have_content 'Cidade não pode ficar em branco'
    expect(page).to have_content 'CEP não pode ficar em branco'
  end
end