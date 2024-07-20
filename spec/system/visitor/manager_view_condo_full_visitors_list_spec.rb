require 'rails_helper'

describe 'Manager view condo full visitors list' do
  it 'from visitors agenda' do
    manager = create :manager
    first_condo = create :condo, name: 'Condomínio Teste'
    tower = create :tower, condo: first_condo, name: 'Torre A'
    second_condo = create :condo
    first_resident = create :resident, full_name: 'Alberto Silveira', residence: tower.floors[0].units[0]
    second_resident = create :resident, full_name: 'Maria Silveira', residence: tower.floors[0].units[1]
    first_visitor = create :visitor, condo: first_condo, resident: first_resident,
                                     visit_date: Time.zone.today, full_name: 'João da Silva', identity_number: '12467'
    second_visitor = create :visitor, condo: first_condo, resident: first_resident,
                                      category: :employee, recurrence: :weekly,
                                      visit_date: Time.zone.today, full_name: 'Maria Oliveira', identity_number: '45977'
    third_visitor = create :visitor, condo: first_condo, resident: second_resident,
                                     visit_date: 1.day.from_now, full_name: 'Marcos Lima', identity_number: '12345'
    fourth_visitor = create :visitor, condo: second_condo,
                                      visit_date: Time.zone.today, full_name: 'Juliana Ferreira'

    login_as manager, scope: :manager
    visit find_condo_visitors_path first_condo
    click_on 'Ver Lista Completa'

    expect(page).to have_content 'Visitantes/Funcionários cadastrados no Condomínio Teste'
    expect(current_path).to eq all_condo_visitors_path first_condo
    within("#visitor-#{first_visitor.id}") do
      expect(page).to have_content 'João da Silva'
      expect(page).to have_content '12467'
      expect(page).to have_content 'Visitante'
      expect(page).to have_content 'Torre A - 11'
      expect(page).to have_content 'Alberto Silveira'
      expect(page).to have_content I18n.l(Time.zone.today)
    end
    within("#visitor-#{second_visitor.id}") do
      expect(page).to have_content 'Maria Oliveira'
      expect(page).to have_content '45977'
      expect(page).to have_content 'Funcionário'
      expect(page).to have_content 'Torre A - 11'
      expect(page).to have_content 'Alberto Silveira'
      expect(page).to have_content I18n.l(Time.zone.today)
      expect(page).to have_content 'Semanal'
    end
    within("#visitor-#{third_visitor.id}") do
      expect(page).to have_content 'Marcos Lima'
      expect(page).to have_content '12345'
      expect(page).to have_content 'Visitante'
      expect(page).to have_content 'Torre A - 12'
      expect(page).to have_content 'Maria Silveira'
      expect(page).to have_content I18n.l(1.day.from_now.to_date)
    end
    expect(page).not_to have_css "#visitor-#{fourth_visitor.id}"
    expect(page).not_to have_content 'Juliana Ferreira'
  end

  it 'and sees if list is empty' do
    manager = create :manager
    condo = create :condo

    login_as manager, scope: :manager
    visit all_condo_visitors_path condo

    expect(page).to have_content 'No momento, não há visitantes cadastrados para este condomínio'
  end

  context 'and search visitors' do
    it 'with identity number filter' do
      manager = create :manager
      resident = create :resident, :with_residence, full_name: 'Alberto Silveira'
      condo = resident.residence.condo
      first_visitor = create :visitor, condo:, resident:,
                                       visit_date: Time.zone.today, full_name: 'João da Silva', identity_number: '12467'
      second_visitor = create :visitor, condo:, resident:,
                                        category: :employee, recurrence: :weekly,
                                        visit_date: Time.zone.today, full_name: 'Maria Lima', identity_number: '4677811'
      create :visitor, condo:, full_name: 'Marcos Lima', identity_number: '12345'

      login_as manager, scope: :manager
      visit all_condo_visitors_path condo
      fill_in 'RG', with: '467'
      click_on 'Pesquisar'

      expect(page).to have_content '2 visitantes encontrados'
      within("#visitor-#{first_visitor.id}") do
        expect(page).to have_content 'João da Silva'
        expect(page).to have_content '12467'
        expect(page).to have_content 'Visitante'
        expect(page).to have_content 'Torre A - 11'
        expect(page).to have_content 'Alberto Silveira'
        expect(page).to have_content I18n.l(Time.zone.today)
      end
      within("#visitor-#{second_visitor.id}") do
        expect(page).to have_content 'Maria Lima'
        expect(page).to have_content '4677811'
        expect(page).to have_content 'Funcionário'
        expect(page).to have_content 'Torre A - 11'
        expect(page).to have_content 'Alberto Silveira'
        expect(page).to have_content I18n.l(Time.zone.today)
        expect(page).to have_content 'Semanal'
      end
      expect(page).not_to have_content 'Marcos Lima'
    end
    it 'with visitors name filter' do
      manager = create :manager
      resident = create :resident, :with_residence, full_name: 'Alberto Silveira'
      condo = resident.residence.condo
      first_visitor = create :visitor, condo:, resident:,
                                       visit_date: Time.zone.today, full_name: 'João da Silva', identity_number: '12467'
      second_visitor = create :visitor, condo:, resident:,
                                        category: :employee, recurrence: :weekly,
                                        visit_date: 2.days.from_now, full_name: 'João Sousa', identity_number: '13331'
      create :visitor, condo:, full_name: 'Marcos Lima', identity_number: '12345'

      login_as manager, scope: :manager
      visit all_condo_visitors_path condo
      fill_in 'Nome do Visitante', with: 'João'
      click_on 'Pesquisar'

      expect(page).to have_content '2 visitantes encontrados'
      within("#visitor-#{first_visitor.id}") do
        expect(page).to have_content 'João da Silva'
        expect(page).to have_content '12467'
        expect(page).to have_content 'Visitante'
        expect(page).to have_content 'Torre A - 11'
        expect(page).to have_content 'Alberto Silveira'
        expect(page).to have_content I18n.l(Time.zone.today)
      end
      within("#visitor-#{second_visitor.id}") do
        expect(page).to have_content 'João Sousa'
        expect(page).to have_content '13331'
        expect(page).to have_content 'Funcionário'
        expect(page).to have_content 'Torre A - 11'
        expect(page).to have_content 'Alberto Silveira'
        expect(page).to have_content I18n.l(2.days.from_now.to_date)
        expect(page).to have_content 'Semanal'
      end
      expect(page).not_to have_content 'Marcos Lima'
    end
    it 'with resident name filter' do
      manager = create :manager
      resident = create :resident, :with_residence, full_name: 'Alberto Silveira'
      condo = resident.residence.condo
      first_visitor = create :visitor, condo:, resident:,
                                       visit_date: Time.zone.today, full_name: 'João da Silva', identity_number: '12467'
      second_visitor = create :visitor, condo:, resident:,
                                        category: :employee, recurrence: :weekly,
                                        visit_date: 2.days.from_now, full_name: 'Bruna Lima', identity_number: '13331'
      create :visitor, condo:, full_name: 'Marcos Lima', identity_number: '12345'

      login_as manager, scope: :manager
      visit all_condo_visitors_path condo
      fill_in 'Nome do Morador', with: 'Alberto'
      click_on 'Pesquisar'

      expect(page).to have_content '2 visitantes encontrados'
      within("#visitor-#{first_visitor.id}") do
        expect(page).to have_content 'João da Silva'
        expect(page).to have_content '12467'
        expect(page).to have_content 'Visitante'
        expect(page).to have_content 'Torre A - 11'
        expect(page).to have_content 'Alberto Silveira'
        expect(page).to have_content I18n.l(Time.zone.today)
      end
      within("#visitor-#{second_visitor.id}") do
        expect(page).to have_content 'Bruna Lima'
        expect(page).to have_content '13331'
        expect(page).to have_content 'Funcionário'
        expect(page).to have_content 'Torre A - 11'
        expect(page).to have_content 'Alberto Silveira'
        expect(page).to have_content I18n.l(2.days.from_now.to_date)
        expect(page).to have_content 'Semanal'
      end
      expect(page).not_to have_content 'Marcos Lima'
    end

    it 'with visit date filter' do
      manager = create :manager
      resident = create :resident, :with_residence, full_name: 'Alberto Silveira'
      condo = resident.residence.condo
      first_visitor = create :visitor, condo:, resident:,
                                       visit_date: 2.days.from_now, full_name: 'João da Silva', identity_number: '12467'
      second_visitor = create :visitor, condo:, resident:,
                                        category: :employee, recurrence: :weekly,
                                        visit_date: 2.days.from_now, full_name: 'Bruna Lima', identity_number: '13331'
      create :visitor, condo:, full_name: 'Marcos Lima', identity_number: '12345'

      login_as manager, scope: :manager
      visit all_condo_visitors_path condo
      fill_in 'Data Autorizada', with: 2.days.from_now.to_date
      click_on 'Pesquisar'

      expect(page).to have_content '2 visitantes encontrados'
      within("#visitor-#{first_visitor.id}") do
        expect(page).to have_content 'João da Silva'
        expect(page).to have_content '12467'
        expect(page).to have_content 'Visitante'
        expect(page).to have_content 'Torre A - 11'
        expect(page).to have_content 'Alberto Silveira'
        expect(page).to have_content I18n.l(2.days.from_now.to_date)
      end
      within("#visitor-#{second_visitor.id}") do
        expect(page).to have_content 'Bruna Lima'
        expect(page).to have_content '13331'
        expect(page).to have_content 'Funcionário'
        expect(page).to have_content 'Torre A - 11'
        expect(page).to have_content 'Alberto Silveira'
        expect(page).to have_content I18n.l(2.days.from_now.to_date)
        expect(page).to have_content 'Semanal'
      end
      expect(page).not_to have_content 'Marcos Lima'
    end

    it 'with all filters' do
      manager = create :manager
      resident = create :resident, :with_residence, full_name: 'Alberto Silveira'
      condo = resident.residence.condo
      first_visitor = create :visitor, condo:, resident:,
                                       visit_date: 2.days.from_now, full_name: 'João da Silva', identity_number: '12467'
      create :visitor, condo:, full_name: 'Bruna Lima'
      create :visitor, condo:, full_name: 'Marcos Ferreira'

      login_as manager, scope: :manager
      visit all_condo_visitors_path condo
      fill_in 'Nome do Visitante', with: 'João da Silva'
      fill_in 'RG', with: '12467'
      fill_in 'Nome do Morador', with: 'Alberto Silveira'
      fill_in 'Data Autorizada', with: 2.days.from_now.to_date
      click_on 'Pesquisar'

      expect(page).to have_content '1 visitante encontrado'
      within("#visitor-#{first_visitor.id}") do
        expect(page).to have_content 'João da Silva'
        expect(page).to have_content '12467'
        expect(page).to have_content 'Visitante'
        expect(page).to have_content 'Torre A - 11'
        expect(page).to have_content 'Alberto Silveira'
        expect(page).to have_content I18n.l(2.days.from_now.to_date)
      end
      expect(page).not_to have_content 'Bruna Lima'
      expect(page).not_to have_content 'Marcos Ferreira'
    end

    it 'with no filters' do
      manager = create :manager
      condo = create :condo
      create :visitor, condo:, full_name: 'João da Silva'
      create :visitor, condo:, full_name: 'Bruna Lima'
      create :visitor, condo:, full_name: 'Marcos Ferreira'

      login_as manager, scope: :manager
      visit all_condo_visitors_path condo
      fill_in 'Nome do Visitante', with: ''
      fill_in 'RG', with: ''
      fill_in 'Nome do Morador', with: ''
      fill_in 'Data Autorizada', with: ''
      click_on 'Pesquisar'

      expect(page).to have_content 'João da Silva'
      expect(page).to have_content 'Bruna Lima'
      expect(page).to have_content 'Marcos Ferreira'
      expect(page).not_to have_content '3 resultados encontrados'
    end

    it 'and finds no one' do
      manager = create :manager
      condo = create :condo
      create :visitor, condo:, full_name: 'João da Silva'
      create :visitor, condo:, full_name: 'Bruna Lima'
      create :visitor, condo:, full_name: 'Marcos Ferreira'

      login_as manager, scope: :manager
      visit all_condo_visitors_path condo
      fill_in 'Nome do Visitante', with: 'Pedro'
      click_on 'Pesquisar'

      expect(page).to have_content 'Não foi possível encontrar visitantes com os filtros informados'
    end
  end
end
