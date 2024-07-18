require 'rails_helper'

describe 'Manager view condo visitors list' do
  context 'from condo dashboard' do
    it "and sees today's visitors" do
      manager = create :manager
      first_condo = create :condo
      second_condo = create :condo
      create :visitor, condo: first_condo, visit_date: Time.zone.today, full_name: 'João da Silva'
      create :visitor, condo: first_condo, visit_date: Time.zone.today, full_name: 'Maria Oliveira'
      create :visitor, condo: first_condo, visit_date: 1.day.from_now, full_name: 'Marcos Lima'
      create :visitor, condo: second_condo, visit_date: Time.zone.today, full_name: 'Juliana Ferreira'

      login_as manager, scope: :manager
      visit condo_path first_condo

      within('#todays-visitors') do
        expect(page).to have_content 'João da Silva'
        expect(page).to have_content 'Maria Oliveira'
        expect(page).not_to have_content 'Marcos Lima'
        expect(page).not_to have_content 'Juliana Ferreira'
      end
    end

    it "and today's visitors list is empty" do
      manager = create :manager
      first_condo = create :condo
      second_condo = create :condo
      create :visitor, condo: second_condo, visit_date: Time.zone.today, full_name: 'João da Silva'
      create :visitor, condo: second_condo, visit_date: Time.zone.today, full_name: 'Maria Oliveira'

      login_as manager, scope: :manager
      visit condo_path first_condo

      within('#todays-visitors') do
        expect(page).to have_content 'Não há visitantes/funcionários esperados para hoje.'
        expect(page).not_to have_content 'João da Silva'
        expect(page).not_to have_content 'Maria Oliveira'
      end
    end
  end
end
