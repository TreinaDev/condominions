require 'rails_helper'

describe 'Manager edits condo' do
  it 'must be authenticated as manager' do
    condo = create(:condo)
    visit edit_condo_path(condo)

    expect(current_path).to eq new_manager_session_path
  end

  it 'sucessfully' do
    manager = create(:manager)
    condo = create(:condo)

    login_as(manager, scope: :manager)
    visit condo_path(condo)

    click_on 'Editar'

    fill_in 'Nome',	with: 'Condominio Editado'
    fill_in 'CNPJ', with: '34.474.564/0001-88'
    fill_in 'Logradouro', with: 'Rua ST'
    fill_in 'Nº', with: '12'
    fill_in 'Bairro', with: 'Santa Terezinha'
    fill_in 'Cidade', with: 'Brusque'
    select 'SC', from: 'Estado'
    fill_in 'CEP', with: '88352-272'
    click_on 'Salvar'

    expect(current_path).to eq condo_path(condo)
    expect(page).to have_content 'Condomínio atualizado com sucesso'
    expect(page).to have_content 'Condominio Editado'
    expect(page).to have_content 'CNPJ: 34.474.564/0001-88'
    expect(page).to have_content 'Endereço: Rua ST, 12, Santa Terezinha - Brusque/SC - CEP: 88352-272'
  end

  it 'with missing params' do
    manager = create(:manager)
    condo = create :condo, name: 'Condominio Residencial Paineiras'

    login_as(manager, scope: :manager)
    visit condo_path(condo)
    click_on 'Editar'

    fill_in 'CNPJ', with: ''
    fill_in 'Cidade', with: ''
    fill_in 'CEP', with: ''
    click_on 'Salvar'

    expect(current_path).to eq edit_condo_path(condo)
    expect(page).to have_content 'CNPJ inválido'
    expect(page).to have_content 'Cidade não pode ficar em branco'
    expect(page).to have_content 'CEP inválido'
  end
end
