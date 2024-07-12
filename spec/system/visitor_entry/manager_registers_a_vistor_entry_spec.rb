require 'rails_helper'

describe 'Manager registers a visitor entry' do
  it 'and must be authenticated' do
    condo = create(:condo)

    visit new_condo_visitor_entry_path condo

    expect(current_path).to eq new_manager_session_path
  end

  it 'successfully without reference a unit' do
    manager = create(:manager)
    condo = create(:condo)

    login_as manager, scope: :manager
    visit new_condo_visitor_entry_path condo
    fill_in 'Nome Completo',	with: 'João da silva'
    fill_in 'RG',	with: '123456789'
    select '', from: 'Unidade visitada'
    click_on 'Criar Entrada de Visitante'

    expect(page).to have_content('Entrada de visitante registrada com sucesso')
    expect(current_path).to eq condo_visitor_entries_path(condo)
    expect(page).to have_content('João da silva')
    expect(page).to have_content('123456789')
    expect(page).to have_content('Sem unidade referenciada')
    expect(page).to have_content(I18n.l(VisitorEntry.last.created_at, format: :long))
  end

  it 'successfully with reference to a unit' do
    manager = create(:manager)
    condo = create(:condo)
    unit_type = create(:unit_type, condo:)
    create(:tower, :with_four_units, condo:, name: 'Torre A', unit_types: [unit_type])

    login_as manager, scope: :manager
    visit new_condo_visitor_entry_path condo
    fill_in 'Nome Completo',	with: 'João da silva'
    fill_in 'RG',	with: '123456789'
    select 'Torre A - 11', from: 'Unidade visitada'
    click_on 'Criar Entrada de Visitante'

    expect(page).to have_content('Entrada de visitante registrada com sucesso')
    expect(current_path).to eq condo_visitor_entries_path condo
    expect(page).to have_content('João da silva')
    expect(page).to have_content('123456789')
    expect(page).to have_content('Torre A')
    expect(page).to have_content('11')
    expect(page).to have_content(I18n.l(VisitorEntry.last.created_at, format: :long))
  end

  it 'with missing params' do
    manager = create(:manager)
    condo = create(:condo)

    login_as manager, scope: :manager
    visit new_condo_visitor_entry_path condo
    click_on 'Criar Entrada de Visitante'

    expect(page).to have_content('Não foi possível registrar entrada de visitante')
    expect(current_path).to eq new_condo_visitor_entry_path condo
    expect(page).to have_content('Nome Completo não pode ficar em branco')
    expect(page).to have_content('RG não pode ficar em branco')
  end

  it 'identity number must be numbers and letters only' do
    manager = create(:manager)
    condo = create(:condo)

    login_as manager, scope: :manager
    visit new_condo_visitor_entry_path condo
    click_on 'Criar Entrada de Visitante'

    expect(page).to have_content('Não foi possível registrar entrada de visitante')
    expect(current_path).to eq new_condo_visitor_entry_path(condo)
    expect(page).to have_content('só pode ter números e letras')
  end
end
