require 'rails_helper'

describe 'Manager registers new manager' do
  it 'from the menu' do
    manager = create(:manager)

    login_as(manager, scope: :manager)
    visit root_path
    within('nav') { click_on 'Cadastrar novo administrador' }
    save_page
    fill_in 'Nome Completo', with: 'Erika Campos'
    fill_in 'CPF', with: CPF.generate
    fill_in 'E-mail', with: 'admin@email.com'
    fill_in 'Senha', with: 'password'
    attach_file 'Foto', Rails.root.join('spec/support/images/manager_photo.jpg')
    click_on 'Cadastrar'

    expect(page).to have_content 'Administrador cadastrado com sucesso - Nome: Erika Campos | Email: admin@email.com'
  end

  it 'with incomplete data' do
    manager = create(:manager)

    login_as(manager, scope: :manager)
    visit root_path
    within('nav') { click_on 'Cadastrar novo administrador' }
    fill_in 'Nome Completo', with: ''
    fill_in 'CPF', with: ''
    click_on 'Cadastrar'

    expect(page).to have_content 'Não foi possível cadastrar novo administrador'
    expect(page).to have_content 'Nome Completo não pode ficar em branco'
    expect(page).to have_content 'CPF não pode ficar em branco'
  end

  it 'and must be authenticated' do
    visit new_manager_path

    expect(current_path).to eq new_manager_session_path
  end
end
