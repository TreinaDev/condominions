require 'rails_helper'

describe 'Manager deletes announcement' do
  it 'successfully' do
    manager = create :manager, full_name: 'Rodrigo Silva', is_super: false
    condo = create :condo
    condo.managers << manager
    create :announcement, condo:, manager:, title: 'Reunião de condomínio',
                          message: 'Este é um aviso importante para todos os moradores'

    login_as manager, scope: :manager
    visit condo_announcements_path condo
    within(:css, '.announcement_board .announcement:nth-of-type(1)') do
      click_on 'Visualizar'
    end
    accept_confirm do
      click_link 'Excluir'
    end

    expect(page).to have_current_path condo_path(condo), wait: 3
    expect(page).to have_content 'Aviso removido com sucesso'
  end
end
