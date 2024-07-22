require 'rails_helper'

describe 'Manager registers announcement' do
  it 'and must be authenticated' do
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
    find('#announcement_message').click.set('Todos os moradores devem fazer silêncio.')
    click_on 'Salvar'

    expect(page).to have_current_path condo_path condo
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

  it 'with missing params' do
    manager = create :manager, full_name: 'Rodrigo Silva'
    condo = create :condo
    condo.managers << manager

    login_as manager, scope: :manager
    visit condo_path condo
    within '#announcement_board' do
      click_on 'Novo'
    end
    fill_in 'Título', with: ''
    click_on 'Salvar'

    expect(page).to have_current_path new_condo_announcement_path condo
    expect(page).to have_content 'Mensagem não pode ficar em branco'
    expect(page).to have_content 'Título não pode ficar em branco'
  end
end
