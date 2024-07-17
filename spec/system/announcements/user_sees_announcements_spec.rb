require 'rails_helper'

describe 'User sees announcements' do
  it 'with more than 3 announcements' do
    manager = create :manager, full_name: 'Rodrigo Silva'
    condo = create :condo
    condo.managers << manager
    announcement1 = create :announcement, condo:, manager:, title: 'Reunião de condomínio'
    create :announcement, condo:, manager:, title: 'Manutenção do elevador'
    create :announcement, condo:, manager:, title: 'Limpeza de fachada'
    create :announcement, condo:, manager:, title: 'Horário de coleta de lixo'

    login_as manager, scope: :manager
    visit condo_path condo
    within '#annoucement_board' do
      click_on 'ver mais'
    end

    expect(current_path).to eq condo_announcements_path condo
    expect(page).to have_content 'Reunião de condomínio'
    expect(page).to have_content 'Rodrigo Silva'
    expect(page).to have_content "Atualizado em: #{announcement1.updated_at}"
  end
end
