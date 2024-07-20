require 'rails_helper'

describe 'Manager edits announcement' do
  it 'successfully' do
    manager = create :manager, full_name: 'Rodrigo Silva', is_super: false
    condo = create :condo
    condo.managers << manager
    announcement = create :announcement, condo:, manager:, title: 'Reunião de condomínio',
                                         message: 'Este é um aviso importante para todos os moradores'

    login_as manager, scope: :manager
    visit condo_announcements_path condo
    within(:css, '.announcement_board .announcement:nth-of-type(1)') do
      click_on 'Visualizar'
    end
    click_on 'Editar'

    fill_in 'Título', with: 'Aviso Importante'
    fill_in_trix_editor 'announcement_message', with: 'Todos os moradores devem fazer silêncio.'
    click_on 'Salvar'

    expect(page).to have_current_path announcement_path announcement
    expect(page).to have_content 'Aviso Importante'
    expect(page).to have_content 'Todos os moradores devem fazer silêncio.'
    expect(page).to have_content 'Aviso atualizado com sucesso'
  end

  it 'and fails due blank fields' do
    manager = create :manager, full_name: 'Rodrigo Silva', is_super: false
    condo = create :condo
    condo.managers << manager
    announcement = create :announcement, condo:, manager:, title: 'Reunião de condomínio',
                                         message: 'Este é um aviso importante para todos os moradores'

    login_as manager, scope: :manager
    visit condo_announcements_path condo
    within(:css, '.announcement_board .announcement:nth-of-type(1)') do
      click_on 'Visualizar'
    end
    click_on 'Editar'

    fill_in 'Título', with: ''
    execute_script("document.querySelector('#announcement_message').editor.loadHTML('')")
    click_on 'Salvar'

    expect(current_path).to eq edit_announcement_path announcement
    expect(page).to have_content 'Título não pode ficar em branco'
    expect(page).to have_content 'Mensagem não pode ficar em branco'
  end
end
