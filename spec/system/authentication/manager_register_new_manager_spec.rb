require 'rails_helper'

describe 'Administrador cadastra novo administrador' do
  it 'a partir do menu' do
    manager = Manager.create!(email: 'manager@email.com', password: 'senha123', full_name: 'João Almeida',
                              registration_number: CPF.generate)

    login_as(manager, scope: :manager)
    visit root_path
    within('nav') { click_on 'Cadastrar novo administrador' }
    fill_in 'Nome Completo', with: 'Erika Campos'
    fill_in 'CPF', with: CPF.generate
    fill_in 'E-mail', with: 'admin@email.com'
    fill_in 'Senha', with: 'password'
    attach_file 'Foto', Rails.root.join('spec/support/images/manager_photo.jpg')
    click_on 'Cadastrar'

    expect(page).to have_content 'Administrador cadastrado com sucesso.'
    expect(Manager.last.full_name).to eq 'Erika Campos'
  end

  it 'com dados incompletos' do
    manager = Manager.create!(email: 'manager@email.com', password: 'senha123', full_name: 'João Almeida',
                              registration_number: CPF.generate)

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

  it 'e deve estar autenticado' do
    visit new_manager_path

    expect(current_path).to eq new_manager_session_path
  end
end
