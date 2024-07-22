require 'rails_helper'

describe 'Manager delete superintendent' do
  it 'from condo details page' do
    condo = create :condo, name: 'Condomínio X'
    travel_to '2024-07-21'.to_date
    tower = create(:tower, condo:)
    unit11 = tower.floors.first.units.first
    resident = create :resident, full_name: 'Dona Alvara', residence: unit11, email: 'alvara@email.com'
    create(:superintendent, condo:, tenant: resident, start_date: '2024-07-21'.to_date,
                            end_date: '2024-07-25'.to_date)
    manager = create :manager

    login_as manager, scope: :manager
    visit condo_path condo
    click_on 'Dona Alvara'

    click_on 'Encerrar Gestão'

    expect(page).to have_content 'Mandato de síndico encerrado com sucesso!'
    expect(current_path).to eq condo_path condo
    expect(Superintendent.last.closed?).to eq true
  end
end
