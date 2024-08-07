require 'rails_helper'

describe 'Manager view condo visitors list' do
  it 'from condo dashboard' do
    manager = create :manager
    tower = create :tower, name: 'Torre A'
    resident = create :resident, full_name: 'Alberto Silveira', residence: tower.floors[0].units[0]
    first_condo = create :condo
    second_condo = create :condo
    first_visitor = create :visitor, condo: first_condo, resident:,
                                     visit_date: Date.current, full_name: 'João da Silva', identity_number: '12467'
    second_visitor = create :visitor, condo: first_condo, resident:,
                                      visit_date: Date.current, full_name: 'Maria Oliveira', identity_number: '45977'
    third_visitor = create :visitor, condo: first_condo,
                                     visit_date: 1.day.from_now, full_name: 'Marcos Lima'
    fourth_visitor = create :visitor, condo: second_condo,
                                      visit_date: Date.current, full_name: 'Juliana Ferreira'

    login_as manager, scope: :manager
    visit condo_path first_condo
    click_on 'Agenda de visitantes/funcionários'

    expect(page).to have_content I18n.l(Date.current, format: :long)
    within("#visitor-#{first_visitor.id}") do
      expect(page).to have_content 'Alberto Silveira'
      expect(page).to have_content 'João da Silva'
      expect(page).to have_content '12467'
      expect(page).to have_content 'Torre A - 11'
    end
    within("#visitor-#{second_visitor.id}") do
      expect(page).to have_content 'Alberto Silveira'
      expect(page).to have_content 'Maria Oliveira'
      expect(page).to have_content '45977'
      expect(page).to have_content 'Torre A - 11'
    end
    expect(page).not_to have_css "#visitor-#{third_visitor.id}"
    expect(page).not_to have_css "#visitor-#{fourth_visitor.id}"
    expect(page).not_to have_content 'Marcos Lima'
    expect(page).not_to have_content 'Juliana Ferreira'
  end

  it 'and can change the day forward' do
    manager = create :manager
    tower = create :tower, name: 'Torre A'
    resident = create :resident, full_name: 'Alberto Silveira', residence: tower.floors[0].units[0]
    first_condo = create :condo
    second_condo = create :condo
    first_visitor = create :visitor, condo: first_condo, resident:,
                                     visit_date: 1.day.from_now, full_name: 'João da Silva', identity_number: '12467'
    second_visitor = create :visitor, condo: first_condo, resident:,
                                      visit_date: 1.day.from_now, full_name: 'Maria Oliveira', identity_number: '45977'
    third_visitor = create :visitor, condo: first_condo, resident:,
                                     visit_date: Date.current, full_name: 'Marcos Lima'
    fourth_visitor = create :visitor, condo: second_condo,
                                      visit_date: 1.day.from_now, full_name: 'Juliana Ferreira'

    login_as manager, scope: :manager
    visit find_condo_visitors_path first_condo
    click_on 'Dia Seguinte'

    expect(page).to have_content I18n.l(Date.current + 1.day, format: :long)
    within("#visitor-#{first_visitor.id}") do
      expect(page).to have_content 'Alberto Silveira'
      expect(page).to have_content 'João da Silva'
      expect(page).to have_content '12467'
      expect(page).to have_content 'Torre A - 11'
    end
    within("#visitor-#{second_visitor.id}") do
      expect(page).to have_content 'Alberto Silveira'
      expect(page).to have_content 'Maria Oliveira'
      expect(page).to have_content '45977'
      expect(page).to have_content 'Torre A - 11'
    end
    expect(page).not_to have_css "#visitor-#{third_visitor.id}"
    expect(page).not_to have_css "#visitor-#{fourth_visitor.id}"
    expect(page).not_to have_content 'Marcos Lima'
    expect(page).not_to have_content 'Juliana Ferreira'
  end

  it 'and can change the day backward' do
    manager = create :manager
    tower = create :tower, name: 'Torre A'
    resident = create :resident, full_name: 'Alberto Silveira', residence: tower.floors[0].units[0]
    first_condo = create :condo
    second_condo = create :condo
    first_visitor = create :visitor, condo: first_condo, resident:,
                                     visit_date: Date.current, full_name: 'João da Silva', identity_number: '12467'
    second_visitor = create :visitor, condo: first_condo, resident:,
                                      visit_date: Date.current, full_name: 'Maria Oliveira', identity_number: '45977'
    third_visitor = create :visitor, condo: first_condo, resident:,
                                     visit_date: 1.day.from_now, full_name: 'Marcos Lima'
    fourth_visitor = create :visitor, condo: second_condo,
                                      visit_date: Date.current, full_name: 'Juliana Ferreira'

    login_as manager, scope: :manager
    visit find_condo_visitors_path(first_condo, date: 1.day.from_now)
    click_on 'Dia Anterior'

    expect(page).to have_content I18n.l(Date.current, format: :long)
    within("#visitor-#{first_visitor.id}") do
      expect(page).to have_content 'Alberto Silveira'
      expect(page).to have_content 'João da Silva'
      expect(page).to have_content '12467'
      expect(page).to have_content 'Torre A - 11'
    end
    within("#visitor-#{second_visitor.id}") do
      expect(page).to have_content 'Alberto Silveira'
      expect(page).to have_content 'Maria Oliveira'
      expect(page).to have_content '45977'
      expect(page).to have_content 'Torre A - 11'
    end
    expect(page).not_to have_css "#visitor-#{third_visitor.id}"
    expect(page).not_to have_css "#visitor-#{fourth_visitor.id}"
    expect(page).not_to have_content 'Marcos Lima'
    expect(page).not_to have_content 'Juliana Ferreira'
    expect(page).not_to have_link 'Dia Anterior'
  end

  it 'and cannot access a past day' do
    manager = create :manager
    condo = create :condo

    login_as manager, scope: :manager
    visit find_condo_visitors_path(condo, date: 1.day.ago)

    expect(page).to have_content 'Não é possível acessar uma data passada'
    expect(current_path).to eq find_condo_visitors_path(condo)
    expect(page).to have_content I18n.l(Date.current, format: :long)
  end

  it 'must be authenticated' do
    condo = create :condo

    visit find_condo_visitors_path condo

    expect(page).to have_content 'Para continuar, faça login ou registre-se.'
    expect(current_path).to eq new_manager_session_path
  end

  it 'and must be associated' do
    manager = create :manager, is_super: false
    condo = create :condo

    login_as manager, scope: :manager
    visit find_condo_visitors_path condo

    expect(current_path).to eq root_path
    expect(page).to have_content 'Você não tem permissão para fazer isso'
  end

  it 'and cannot be authenticated as a resident' do
    resident = create :resident
    condo = create :condo

    login_as resident, scope: :resident
    visit find_condo_visitors_path condo

    expect(current_path).to eq root_path
  end

  context 'and confirms presence of a visitor' do
    it 'for today' do
      manager = create :manager
      condo = create :condo
      resident = create(:resident, :with_residence, condo:)
      visitor = create :visitor, condo:, resident:, visit_date: Date.current, full_name: 'João Almeida'

      login_as manager, scope: :manager
      visit find_condo_visitors_path condo
      within("#visitor-#{visitor.id}") { page.accept_confirm { find('.confirm').click } }

      expect(current_path).to eq find_condo_visitors_path condo
      expect(page).to have_content 'Entrada do visitante registrada com sucesso'
      expect(VisitorEntry.where(full_name: 'João Almeida').any?).to be true
      expect(visitor.reload.status).to eq 'confirmed'
      within("#visitor-#{visitor.id}") do
        expect(page).not_to have_css '.confirm'
        expect(page).to have_content('Entrada Confirmada')
      end
    end
  end
end
