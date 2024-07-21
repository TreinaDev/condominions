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
    first_condo = create :condo
    second_condo = create :condo
    create :visitor_entry, condo: first_condo, full_name: 'Nome Primeiro Visitante'
    create :visitor_entry, condo: first_condo, full_name: 'Nome Segundo Visitante'
    create :visitor_entry, condo: second_condo, full_name: 'Nome Terceiro Visitante'

    login_as manager, scope: :manager
    visit condo_visitor_entries_path first_condo

    within('.table > tbody > tr:nth-child(1)') do
      expect(page).to have_content 'Nome Segundo Visitante'
    end
    within('.table > tbody > tr:nth-child(2)') do
      expect(page).to have_content 'Nome Primeiro Visitante'
    end
    expect(page).not_to have_content 'Nome Terceiro Visitante'
  end

  it "and there's no visitors entries" do
    manager = create :manager
    condo = create :condo

    login_as manager, scope: :manager
    visit condo_visitor_entries_path condo

    expect(page).to have_content 'No momento, não há entradas de visitantes cadastradas'
  end

  it 'and a resident cant see the links related to visitors entries' do
    condo = create :condo
    resident = create :resident

    login_as resident, scope: :resident
    visit condo_path condo

    expect(page).not_to have_link 'Registrar entrada de visitante'
    expect(page).not_to have_link 'Lista de Entradas'
  end

  context 'only if authenticated' do
    it 'as manager' do
      condo = create :condo

      visit condo_visitor_entries_path condo

      expect(current_path).to eq new_manager_session_path
    end

    it 'and cannot be authenticated as resident' do
      condo = create :condo
      resident = create :resident

      login_as resident, scope: :resident
      visit condo_visitor_entries_path condo

      expect(page).to have_content 'Você não tem permissão para acessar essa página'
      expect(current_path).to eq root_path
    end
  end

  context 'and search a entry' do
    it 'with full name filter' do
      manager = create :manager
      condo = create :condo
      create :visitor_entry, condo:, full_name: 'Nome Primeiro Visitante'
      create :visitor_entry, condo:, full_name: 'Nome Último Visitante'

      login_as manager, scope: :manager
      visit condo_visitor_entries_path condo
      fill_in 'Nome Completo', with: 'Primeiro'
      click_on 'Pesquisar'

      expect(page).to have_content '1 entrada de visitante encontrada'
      within('.table > tbody > tr:nth-child(1)') { expect(page).to have_content 'Nome Primeiro Visitante' }
      expect(page).not_to have_content 'Nome Último Visitante'
    end

    it 'with visit date filter' do
      manager = create :manager
      condo = create :condo
      travel_to 1.day.ago do
        create :visitor_entry, condo:, full_name: 'Nome Visitante Ontem'
      end
      create :visitor_entry, condo:, full_name: 'Nome Primeiro Visitante'
      create :visitor_entry, condo:, full_name: 'Nome Último Visitante'

      login_as manager, scope: :manager
      visit condo_visitor_entries_path condo
      fill_in 'Data da Visita', with: Time.zone.today
      click_on 'Pesquisar'

      expect(page).to have_content '2 entradas de visitante encontrada'
      within('.table > tbody > tr:nth-child(1)') { expect(page).to have_content 'Nome Último Visitante' }
      within('.table > tbody > tr:nth-child(2)') { expect(page).to have_content 'Nome Primeiro Visitante' }
      expect(page).not_to have_content 'Nome Visitante Ontem'
    end

    it 'with identity number filter' do
      manager = create :manager
      condo = create :condo
      create :visitor_entry, condo:, full_name: 'Nome Primeiro Visitante', identity_number: '145697'
      create :visitor_entry, condo:, full_name: 'Nome Último Visitante', identity_number: '789354'

      login_as manager, scope: :manager
      visit condo_visitor_entries_path condo
      fill_in 'RG', with: '789354'
      click_on 'Pesquisar'

      expect(page).to have_content '1 entrada de visitante encontrada'
      within('.table > tbody > tr:nth-child(1)') { expect(page).to have_content 'Nome Último Visitante' }
      expect(page).not_to have_content 'Nome Primeiro Visitante'
    end

    it 'with all filters' do
      manager = create :manager
      condo = create :condo
      create :visitor_entry, condo:, full_name: 'Nome Primeiro Visitante', identity_number: '145697'
      create :visitor_entry, condo:, full_name: 'Nome Segundo Visitante', identity_number: '789354'
      create :visitor_entry, condo:, full_name: 'Nome Terceiro Visitante', identity_number: '78935447'

      login_as manager, scope: :manager
      visit condo_visitor_entries_path condo
      fill_in 'Nome Completo', with: 'Segundo'
      fill_in 'RG', with: '789354'
      fill_in 'Data da Visita', with: Time.zone.today
      click_on 'Pesquisar'

      expect(page).to have_content '1 entrada de visitante encontrada'
      within('.table > tbody > tr:nth-child(1)') { expect(page).to have_content 'Nome Segundo Visitante' }
      expect(page).not_to have_content 'Nome Primeiro Visitante'
      expect(page).not_to have_content 'Nome Terceiro Visitante'
    end

    it 'with no filters' do
      manager = create :manager
      condo = create :condo
      create :visitor_entry, condo:, full_name: 'Nome Primeiro Visitante'
      create :visitor_entry, condo:, full_name: 'Nome Segundo Visitante'
      create :visitor_entry, condo:, full_name: 'Nome Terceiro Visitante'

      login_as manager, scope: :manager
      visit condo_visitor_entries_path condo
      fill_in 'Nome Completo', with: ''
      fill_in 'RG', with: ''
      fill_in 'Data da Visita', with: ''
      click_on 'Pesquisar'

      within('.table > tbody > tr:nth-child(1)') { expect(page).to have_content 'Nome Terceiro Visitante' }
      within('.table > tbody > tr:nth-child(2)') { expect(page).to have_content 'Nome Segundo Visitante' }
      within('.table > tbody > tr:nth-child(3)') { expect(page).to have_content 'Nome Primeiro Visitante' }
      expect(page).not_to have_content '3 entradas de visitante encontrada'
    end

    it 'and finds no entry' do
      manager = create :manager
      condo = create :condo
      create :visitor_entry, condo:, full_name: 'Nome Primeiro Visitante'
      create :visitor_entry, condo:, full_name: 'Nome Segundo Visitante'

      login_as manager, scope: :manager
      visit condo_visitor_entries_path condo
      fill_in 'Nome Completo', with: 'Terceiro'
      click_on 'Pesquisar'

      expect(page).to have_content '0 entradas de visitante encontradas'
      expect(page).to have_content 'Não foi possível encontrar entradas de visitantes com os filtros informados'
    end
  end
end
