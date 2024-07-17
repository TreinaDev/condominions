require 'rails_helper'

describe 'Resident sees own visitors list' do
  it 'from condo dashboard' do
    condo = create :condo
    tower = create :tower, condo:, floor_quantity: 1, units_per_floor: 2
    first_resident = create :resident, residence: tower.floors[0].units[0], email: 'joao@email.com'
    second_resident = create :resident, residence: tower.floors[0].units[1], email: 'maria@email.com'
    first_visitor = create :visitor, resident: first_resident, full_name: 'João Ferreira', identity_number: 145_364,
                                     visit_date: 2.weeks.from_now, category: :visitor
    second_visitor = create :visitor, resident: first_resident, full_name: 'Maria Almeida', identity_number: 45_897,
                                      visit_date: 1.month.from_now, category: :employee, recurrence: :daily
    third_visitor = create :visitor, resident: second_resident, full_name: 'Fernando Dias'

    login_as first_resident, scope: :resident
    visit condo_path condo
    click_on 'Ver meus visitantes/funcionários registrados'

    expect(page).to have_content 'Meus visitantes/funcionários registrados'
    within("#visitor-#{first_visitor.id}") do
      expect(page).to have_content 'João Ferreira'
      expect(page).to have_content 'Visitante'
      expect(page).to have_content '145364'
      expect(page).to have_content I18n.l(2.weeks.from_now.to_date)
    end
    within("#visitor-#{second_visitor.id}") do
      expect(page).to have_content 'Maria Almeida'
      expect(page).to have_content 'Funcionário'
      expect(page).to have_content '45897'
      expect(page).to have_content I18n.l(1.month.from_now.to_date)
      expect(page).to have_content 'Diariamente'
    end
    expect(page).not_to have_css "#visitor-#{third_visitor.id}"
    expect(page).not_to have_content 'Fernando Dias'
  end

  it "and cannot see another resident's visitors list" do
    tower = create :tower, floor_quantity: 1, units_per_floor: 2
    first_resident = create :resident, residence: tower.floors[0].units[0], email: 'joao@email.com'
    second_resident = create :resident, residence: tower.floors[0].units[1], email: 'maria@email.com'

    login_as first_resident, scope: :resident
    visit resident_visitors_path second_resident

    expect(current_path).to eq root_path
    expect(page).to have_content 'Você não pode administrar visitantes para outra unidade além da sua'
  end

  it 'only if tenant' do
    resident = create :resident

    login_as resident, scope: :resident
    visit resident_visitors_path resident

    expect(current_path).to eq root_path
    expect(page).to have_content 'Apenas moradores podem administrar visitantes'
  end

  context 'only if authenticated' do
    it 'as a resident' do
      resident = create :resident

      visit resident_visitors_path resident

      expect(current_path).to eq new_resident_session_path
      expect(page).to have_content 'Para continuar, faça login ou registre-se.'
    end

    it 'and cannot be authenticated as a manager' do
      resident = create :resident
      manager = create :manager

      login_as manager, scope: :manager
      visit resident_visitors_path resident

      expect(current_path).to eq root_path
      expect(page).to have_content 'Um administrador não pode administrar visitantes para uma unidade'
    end
  end
end
