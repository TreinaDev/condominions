require 'rails_helper'

describe 'User access calendar' do
  context 'as a resident' do
    it 'and sees only confirmed reservations' do
      common_area = create :common_area
      resident = create :resident, :with_residence, condo: common_area.condo, full_name: 'Maria Pereira'

      travel_to '01/07/2024' do
        create :reservation, common_area:, resident:, date: '05/07/2024', status: :confirmed
        create :reservation, common_area:, resident:, date: '08/07/2024', status: :canceled

        login_as resident, scope: :resident
        visit common_area_path common_area
      end

      within('.table > tbody > tr:nth-child(1) > .wday-5') do
        expect(page).to have_content 'Reservado por Maria Pereira'
      end

      within('.table > tbody > tr:nth-child(2) > .wday-1') do
        expect(page).not_to have_content 'Reservado por Maria Pereira'
      end
    end

    it 'and does not see other resident names and buttons on reservations' do
      common_area = create :common_area
      resident = create :resident, :with_residence, condo: common_area.condo, full_name: 'Maria Pereira'
      other_resident = create :resident, full_name: 'José da Silva'

      travel_to '01/07/2024' do
        create :reservation,
               common_area:,
               resident: other_resident,
               date: '08/07/2024',
               status: :confirmed

        login_as resident, scope: :resident
        visit common_area_path common_area
      end

      within('.table > tbody > tr:nth-child(2) > .wday-1') do
        expect(page).to have_content 'Reservado'
        expect(page).not_to have_content 'por José da Silva'
        expect(page).not_to have_button 'Cancelar'
      end
    end
  end

  context 'as a manager' do
    it 'and sees confirmed reservations with details and no buttons' do
      first_resident = create :resident, full_name: 'Maria Pereira'
      second_resident = create :resident, full_name: 'João da Silva'
      common_area = create :common_area
      manager = create :manager

      travel_to '01/07/2024' do
        create :reservation, common_area:, resident: first_resident, date: '05/07/2024', status: :confirmed
        create :reservation, common_area:, resident: second_resident, date: '08/07/2024', status: :confirmed

        login_as manager, scope: :manager
        visit common_area_path common_area
      end

      within('.table > tbody > tr:nth-child(1) > .wday-5') do
        expect(page).to have_content 'Reservado por Maria Pereira'
        expect(page).not_to have_button 'Cancelar'
      end

      within('.table > tbody > tr:nth-child(2) > .wday-1') do
        expect(page).to have_content 'Reservado por João da Silva'
        expect(page).not_to have_button 'Cancelar'
      end
    end
  end
end
