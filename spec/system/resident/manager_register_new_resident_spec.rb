require 'rails_helper'

describe 'Manager registers new resident' do
  it 'from the menu' do
    manager = create :manager

    login_as manager, scope: :manager
    visit root_path
    within 'nav' do
      click_on id: 'side-menu'
      click_on 'Gerenciar usuarios'
      click_on 'Cadastrar morador'
    end

    fill_in 'Nome Completo', with: 'Adroaldo Junior'
    fill_in 'CPF',	with: CPF.generate(format: true)
    fill_in 'E-mail',	with: 'adroaldo@email.com'
    click_on 'Enviar'

    expect(page).to have_content 'Residente cadastrado com sucesso'
    expect(Resident.last.full_name).to eq 'Adroaldo Junior'
    expect(current_path).to eq new_resident_owner_path Resident.last
  end

  it 'must be authenticated' do
    visit new_resident_path

    expect(current_path).to eq new_manager_session_path
  end

  it 'and can only be authenticated as a manager' do
    resident = create :resident

    login_as resident, scope: :resident
    visit new_resident_path

    expect(current_path).to eq root_path
  end

  it 'with incomplete data' do
    manager = create :manager

    login_as manager, scope: :manager
    visit root_path
    within 'nav' do
      click_on id: 'side-menu'
      click_on 'Gerenciar usuarios'
      click_on 'Cadastrar morador'
    end

    fill_in 'Nome Completo', with: ''
    fill_in 'CPF',	with: ''
    fill_in 'E-mail',	with: ''
    click_on 'Enviar'

    expect(page).to have_content 'Nome Completo não pode ficar em branco'
    expect(page).to have_content 'CPF inválido'
  end
end
