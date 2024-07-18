require 'rails_helper'

describe 'Manager registers announcement' do
  it 'must be authenticated' do
    condo = create :condo
    visit new_condo_announcement_path condo

    expect(current_path).to eq signup_choice_path
  end

  it 'successfully' do
    manager = create :manager, full_name: 'Rodrigo Silva'
    condo = create :condo
    condo.managers << manager

    login_as manager, scope: :manager
    visit condo_path condo
    within '#announcement_board' do
      click_on 'Novo'
    end
    fill_in 'Título', with: 'Aviso Importante'
    fill_in 'Mensagem', with: 'Este é um aviso importante para todos os moradores'
    click_on 'Salvar'

    expect(current_path).to eq condo_path condo
    expect(page).to have_content 'Aviso criado com sucesso'

    within '#announcement_board' do
      expect(page).to have_content 'Aviso Importante'
      expect(page).to have_content 'Rodrigo Silva'
      within(:css, '.announcement_board .announcement:nth-of-type(1)') do
        expect(page).to have_link 'Visualizar'
      end
      expect(page).not_to have_content 'ver mais'
    end
  end
end
