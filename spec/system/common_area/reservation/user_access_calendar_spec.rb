require 'rails_helper'

describe 'User access calendar' do
  context 'as a resident' do
    it 'and sees only confirmed reservations' do
      resident = create :resident, full_name: 'Maria Pereira'
      common_area = create :common_area

      travel_to '01/07/2024' do
        confirmed_reservation = create :reservation,
                            common_area:,
                            resident:,
                            date: '05/07/2024',
                            status: :confirmed

        canceled_reservation = create :reservation,
                               common_area:,
                               resident:,
                               date: '08/07/2024',
                               status: :canceled

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

    it 'and does not see other resident names on reservations' do
      resident = create :resident, full_name: 'Maria Pereira'
      other_resident = create :resident, full_name: 'José da Silva'
      common_area = create :common_area

      travel_to '01/07/2024' do
        reservation = create :reservation,
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
      end
    end
  end
end
