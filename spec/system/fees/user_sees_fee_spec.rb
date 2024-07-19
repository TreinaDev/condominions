require 'rails_helper'

describe 'user access condo show' do
  it 'and see fees on dashboard' do
    condo = create :condo
    tower = create :tower, 'condo' => condo, name: 'Torre correta', floor_quantity: 2, units_per_floor: 2
    unit11 = tower.floors[0].units[0]
    resident = create :resident, :mail_confirmed, full_name: 'Adroaldo Silva', residence: unit11
    json_data = Rails.root.join('spec/support/json/two_bills.json').read
    fake_response = double('faraday_response', body: json_data, success?: true)
    allow(Faraday).to receive(:get).with("http://localhost:4000/api/v1/units/#{unit11.id}/bills").and_return(fake_response)

    login_as resident, scope: :resident

    visit condo_path condo
    click_on 'Faturas em Aberto'

    expect(page).to have_content 'Faturas em Aberto'
    expect(page).to have_content 'Vencimento: 10/07/2024'
    expect(page).to have_content 'Valor: R$ 10,00'
    expect(page).to have_content 'Vencimento: 10/05/2024'
    expect(page).to have_content 'Valor: R$ 30,00'
  end
end
