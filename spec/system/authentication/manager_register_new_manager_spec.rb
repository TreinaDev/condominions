require 'rails_helper'

describe 'Administrador cadastra novo administrador' do
  it 'a partir do menu' do
    manager = Manager.create!(email: 'manager@email.com', password: 'senha123', full_name: 'João Almeida',
                              registration_number: '012.345.678-01')

    login_as(manager, scope: :manager)
    visit root_path
    within('nav') { click_on 'Cadastrar novo administrador' }
    fill_in 'Nome Completo', with: 'Erika Campos'
    fill_in 'CPF', with: '012.345.678-10'
    fill_in 'E-mail', with: 'admin@email.com'
    fill_in 'Senha', with: 'password'
    click_on 'Cadastrar'

    expect(page).to have_content 'Administrador cadastrado com sucesso'
    expect(Manager.last.full_name).to eq 'Erika Campos'
  end
end
