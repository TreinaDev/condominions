require 'rails_helper'

describe 'manager see visitor entries list' do
  it 'from condo dashboard' do
    manager = create :manager
    condo = create :condo

    login_as manager, scope: :manager
    visit condo_path condo
    click_on 'Lista de Entradas'

    expect(page).to have_content 'Registros de Entrada de Visitante'
    expect(page).to have_link 'Registrar nova Entrada de Visitante'
    expect(current_path).to eq condo_visitor_entries_path condo
  end

  it 'and the list of visitors appears in descending order of entry (created_at)' do
    manager = create :manager
    condo = create :condo
    create :visitor_entry, condo:, full_name: 'Nome Primeiro Visitante'
    create :visitor_entry, condo:, full_name: 'Nome Último Visitante'

    login_as manager, scope: :manager
    visit condo_visitor_entries_path condo

    within('.table > tbody > tr:nth-child(1)') do
      expect(page).to have_content 'Nome Último Visitante'
    end
    within('.table > tbody > tr:nth-child(2)') do
      expect(page).to have_content 'Nome Primeiro Visitante'
    end
  end
end
