require 'rails_helper'

describe 'Manager edits photo' do
  it 'successfully from the navbar' do
    manager = create :manager

    login_as manager, scope: :manager
    visit root_path
    within('nav') { find('#manager-profile-image').click }
    attach_file 'Foto', Rails.root.join('spec/support/images/manager_photo.jpg')
    click_on 'Enviar'
    manager.reload

    expect(page).to have_current_path root_path
    expect(page).to have_content 'Foto atualizada com sucesso.'
    expect(page).to have_css 'img[src*="manager_photo.jpg"]'
  end
end
