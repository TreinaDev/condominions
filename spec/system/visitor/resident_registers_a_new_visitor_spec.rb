require 'rails_helper'

describe 'Resident registers a new visitor' do
  it 'from condo dashboard' do
    condo = create :condo
    tower = create(:tower, condo:)
    resident = create :resident, residence: tower.floors[0].units[0]

    login_as resident, scope: :resident
    visit condo_path condo
    click_on 'Cadastrar Visitante/Funcionário'
    fill_in 'Nome Completo',	with: 'João da Silva'
    fill_in 'RG',	with: '12311'
    select 'Visitante', from: 'Categoria'
    fill_in 'Data da Visita',	with: 1.month.from_now.to_date
    click_on 'Cadastrar'

    expect(page).to have_content 'Visitante cadastrado com sucesso'
    expect(current_path).to eq resident_visitors_path resident
    expect(page).to have_content 'João da Silva'
    expect(page).to have_content 'Visitante'
    expect(page).to have_content '12311'
    expect(page).to have_content I18n.l(1.month.from_now.to_date)
  end

  it 'as an employee' do
    condo = create :condo
    tower = create(:tower, condo:)
    resident = create :resident, residence: tower.floors[0].units[0]

    login_as resident, scope: :resident
    visit condo_path condo
    click_on 'Cadastrar Visitante/Funcionário'
    fill_in 'Nome Completo',	with: 'João da Silva'
    fill_in 'RG',	with: '12311'
    select 'Funcionário', from: 'Categoria'
    select 'Semanalmente', from: 'Recorrência'
    fill_in 'Data da Visita',	with: 1.month.from_now.to_date
    click_on 'Cadastrar'

    expect(page).to have_content 'Visitante cadastrado com sucesso'
    within("#visitor-#{Visitor.last.id}") do
      expect(page).to have_content 'João da Silva'
      expect(page).to have_content 'Funcionário'
      expect(page).to have_content '12311'
      expect(page).to have_content I18n.l(1.month.from_now.to_date)
      expect(page).to have_content 'Semanalmente'
    end
  end

  it 'only if as a tenant' do
    resident = create :resident

    login_as resident, scope: :resident
    visit new_resident_visitor_path resident

    expect(page).to have_content 'Apenas moradores podem administrar visitantes'
    expect(current_path).to eq root_path
  end

  it 'with missing params' do
    condo = create :condo
    tower = create(:tower, condo:)
    resident = create :resident, residence: tower.floors[0].units[0]

    login_as resident, scope: :resident
    visit new_resident_visitor_path resident
    fill_in 'Nome Completo',	with: ''
    fill_in 'RG',	with: ''
    fill_in 'Data da Visita',	with: ''
    click_on 'Cadastrar'

    expect(page).to have_content 'Erro ao registrar visitante'
    expect(current_path).to eq new_resident_visitor_path resident
    expect(page).to have_content 'Nome Completo não pode ficar em branco'
    expect(page).to have_content 'RG não pode ficar em branco'
    expect(page).to have_content 'Data da Visita não pode ficar em branco'
  end

  it 'date must be future' do
    condo = create :condo
    tower = create(:tower, condo:)
    resident = create :resident, residence: tower.floors[0].units[0]

    login_as resident, scope: :resident
    visit new_resident_visitor_path resident
    fill_in 'Nome Completo',	with: 'João da Silva'
    fill_in 'RG',	with: '12345'
    fill_in 'Data da Visita',	with: 2.days.ago.to_date
    click_on 'Cadastrar'

    expect(page).to have_content 'Erro ao registrar visitante'
    expect(current_path).to eq new_resident_visitor_path resident
    expect(page).to have_content 'Data da Visita deve ser futura'
  end

  context 'identity number' do
    it 'must have at least 5 characters' do
      condo = create :condo
      tower = create(:tower, condo:)
      resident = create :resident, residence: tower.floors[0].units[0]

      login_as resident, scope: :resident
      visit new_resident_visitor_path resident
      fill_in 'Nome Completo',	with: 'João da Silva'
      fill_in 'RG',	with: '1234'
      fill_in 'Data da Visita',	with: 1.month.from_now.to_date
      click_on 'Cadastrar'

      expect(page).to have_content 'Erro ao registrar visitante'
      expect(current_path).to eq new_resident_visitor_path resident
      expect(page).to have_content 'RG é muito curto (mínimo: 5 caracteres)'
    end

    it 'must have a maximum of 10 characters' do
      condo = create :condo
      tower = create(:tower, condo:)
      resident = create :resident, residence: tower.floors[0].units[0]

      login_as resident, scope: :resident
      visit new_resident_visitor_path resident
      fill_in 'Nome Completo',	with: 'João da Silva'
      fill_in 'RG',	with: '12345678911'
      fill_in 'Data da Visita',	with: 1.month.from_now.to_date
      click_on 'Cadastrar'

      expect(page).to have_content 'Erro ao registrar visitante'
      expect(current_path).to eq new_resident_visitor_path resident
      expect(page).to have_content 'RG é muito longo (máximo: 10 caracteres)'
    end

    it 'must have only numbers and letters' do
      condo = create :condo
      tower = create(:tower, condo:)
      resident = create :resident, residence: tower.floors[0].units[0]

      login_as resident, scope: :resident
      visit new_resident_visitor_path resident
      fill_in 'Nome Completo',	with: 'João da Silva'
      fill_in 'RG',	with: '//////'
      fill_in 'Data da Visita',	with: 1.month.from_now.to_date
      click_on 'Cadastrar'

      expect(page).to have_content 'Erro ao registrar visitante'
      expect(current_path).to eq new_resident_visitor_path resident
      expect(page).to have_content 'RG só pode ter números e letras'
    end
  end

  it 'only if authenticated' do
    resident = create :resident

    visit new_resident_visitor_path resident

    expect(current_path).to eq new_resident_session_path
  end

  it 'and cannot register a visitor as a manager' do
    resident = create :resident
    manager = create :manager

    login_as manager, scope: :manager
    visit new_resident_visitor_path resident

    expect(current_path).to eq root_path
    expect(page).to have_content 'Um administrador não pode administrar visitantes para uma unidade'
  end

  it 'and cannot register a visitor to another resident' do
    tower = create :tower, floor_quantity: 1, units_per_floor: 2
    first_resident = create :resident, email: 'joao@email.com', residence: tower.floors[0].units[0]
    second_resident = create :resident, email: 'maria@email.com', residence: tower.floors[0].units[1]

    login_as first_resident, scope: :resident
    visit new_resident_visitor_path second_resident

    expect(current_path).to eq root_path
    expect(page).to have_content 'Você não pode administrar visitantes para outra unidade além da sua'
  end
end
