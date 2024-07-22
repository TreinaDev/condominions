require 'rails_helper'

describe 'User sees announcements' do
  it 'with more than 3 announcements' do
    first_manager = create :manager, full_name: 'Rodrigo Silva', is_super: true
    second_manager = create :manager, full_name: 'Joaquina Rodrigues', is_super: false
    condo = create :condo
    condo.managers << second_manager
    first_announcement = create :announcement, condo:, manager: first_manager, title: 'Reunião de condomínio'
    second_announcement = create :announcement, condo:, manager: first_manager, title: 'Manutenção do elevador'
    third_announcement = create :announcement, condo:, manager: second_manager, title: 'Limpeza de fachada'
    fourth_announcement = create :announcement, condo:, manager: second_manager, title: 'Horário de coleta de lixo'

    login_as first_manager, scope: :manager
    visit condo_path condo
    within '#announcement_board' do
      click_on 'ver mais'
    end

    expect(current_path).to eq condo_announcements_path condo
    expect(page).to have_content 'Reunião de condomínio'
    expect(page).to have_content 'Rodrigo Silva'
    expect(page).to have_content I18n.l(first_announcement.updated_at, format: :custom)

    expect(page).to have_content 'Manutenção do elevador'
    expect(page).to have_content 'Rodrigo Silva'
    expect(page).to have_content I18n.l(second_announcement.updated_at, format: :custom)

    expect(page).to have_content 'Limpeza de fachada'
    expect(page).to have_content 'Joaquina Rodrigues'
    expect(page).to have_content I18n.l(third_announcement.updated_at, format: :custom)

    expect(page).to have_content 'Horário de coleta de lixo'
    expect(page).to have_content 'Joaquina Rodrigues'
    expect(page).to have_content I18n.l(fourth_announcement.updated_at, format: :custom)
  end

  it 'and see the details of an announcement from announcement board' do
    manager = create :manager, is_super: false
    condo = create :condo
    condo.managers << manager
    announcement = create :announcement, condo:, manager:, title: 'Reunião de condomínio'

    login_as manager, scope: :manager
    visit condo_path condo
    within(:css, '.announcement_board .announcement:nth-of-type(1)') do
      click_on 'Visualizar'
    end

    expect(current_path).to eq announcement_path announcement
  end

  it 'and see the details of an announcement from announcement list' do
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

    expect(page).to have_content 'Reunião de condomínio'
    expect(page).to have_content 'Este é um aviso importante para todos os moradores'
    expect(page).to have_content 'Rodrigo Silva'
    expect(page).to have_content announcement.created_at.strftime('%d/%m/%Y %H:%M')
    expect(page).to have_content announcement.updated_at.strftime('%d/%m/%Y %H:%M')
  end
end
