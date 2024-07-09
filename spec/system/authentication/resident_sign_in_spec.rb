require 'rails_helper'

describe 'Resident logs in' do
  it 'successfully' do
    resident = create :resident, full_name: 'Jessica Brito', email: 'jessica@email.com',
                                 password: '123456', status: :confirmed
    resident.user_image.attach io: Rails.root.join('spec/support/images/resident_photo.jpg').open,
                               filename: 'resident_photo.jpg'
    visit root_path
    click_on 'Entrar como morador'
    fill_in 'E-mail', with: 'jessica@email.com'
    fill_in 'Senha', with: '123456'
    click_on 'Entrar'

    expect(page).to have_content 'Login efetuado com sucesso'
    expect(page).not_to have_link 'Entrar como administrador'
    expect(page).to have_link 'Sair'
    expect(page).to have_css 'img[src*="resident_photo.jpg"]'
    expect(page).not_to have_content 'Por favor, cadastre sua foto'
    expect(page).to have_content 'Jessica Brito - jessica@email.com'
    expect(page).not_to have_css '#side_menu'
  end

  it 'and logs out' do
    resident = create :resident, full_name: 'Jessica Brito', email: 'jessica@email.com', password: '123456'

    login_as resident, scope: :resident
    visit root_path
    click_on 'Sair'

    expect(page).to have_content 'Logout efetuado com sucesso'
    expect(page).to have_link 'Entrar como morador'
    expect(page).not_to have_link 'Sair'
    expect(page).not_to have_content 'Jessica Brito - jessica@email.com'
    expect(page).not_to have_css '#side_menu'
  end
end
