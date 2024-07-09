require 'rails_helper'

describe 'Resident edits photo' do
  it 'from warning' do
    resident = create :resident, password: '123456', status: :confirmed

    login_as resident, scope: :resident
    visit root_path
    within('.alert-warning') { click_on 'Editar Foto' }

    expect(current_path).to eq edit_photo_resident_path resident
  end

  it 'from navbar' do
    resident = create :resident, password: '123456', status: :confirmed

    login_as resident, scope: :resident
    visit root_path
    within('nav') { find('#resident-profile-image').click }

    expect(current_path).to eq edit_photo_resident_path resident
  end

  it 'successfully' do
    resident = create :resident, password: '123456', status: :confirmed

    login_as resident, scope: :resident
    visit root_path
    visit edit_photo_resident_path resident
    attach_file 'Foto', Rails.root.join('spec/support/images/resident_photo.jpg')
    click_on 'Enviar'
    resident.reload

    expect(page).to have_current_path root_path
    expect(page).to have_content 'Foto atualizada com sucesso.'
    expect(page).to have_css 'img[src*="resident_photo.jpg"]'
  end
end
