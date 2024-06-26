require 'rails_helper'

describe 'Administrador se autentica' do
  it 'com sucesso' do
    manager = Manager.create!(email: 'manager@email.com', password: 'senha123', full_name: 'João Almeida',
                              registration_number: CPF.generate)
    manager.user_image.attach(io: Rails.root.join('spec/support/images/manager_photo.jpg').open,
                              filename: 'manager_photo.jpg')

    visit root_path
    click_on 'Entrar como administrador'
    fill_in 'E-mail', with: 'manager@email.com'
    fill_in 'Senha', with: 'senha123'
    click_on 'Entrar'

    expect(page).to have_content 'Login efetuado com sucesso.'
    expect(page).not_to have_link 'Entrar como administrador'
    expect(page).to have_link 'Sair'
    expect(page).to have_css 'img[src*="manager_photo.jpg"]'
    expect(page).to have_content 'João Almeida - manager@email.com'
  end

  it 'e faz logout' do
    manager = Manager.create!(email: 'manager@email.com', password: 'senha123', full_name: 'João Almeida',
                              registration_number: CPF.generate)

    login_as(manager, scope: :manager)
    visit root_path
    click_on 'Sair'

    expect(page).to have_content 'Logout efetuado com sucesso.'
    expect(page).to have_link 'Entrar como administrador'
    expect(page).not_to have_link 'Sair'
    expect(page).not_to have_content 'João Almeida - manager@email.com'
  end
end
