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

  it 'as a employee' do
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
      expect(page).to have_content 'Semanalmente'
      expect(page).to have_content '12311'
      expect(page).to have_content I18n.l(1.month.from_now.to_date)
    end
  end

  it 'only if tenant' do
    resident = create :resident

    login_as resident, scope: :resident
    visit new_resident_visitor_path resident

    expect(page).to have_content 'Apenas moradores podem cadastrar visitantes'
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

  it 'only if authenticated' do
    resident = create :resident

    visit new_resident_visitor_path resident

    expect(current_path).to eq new_resident_session_path
  end
end
