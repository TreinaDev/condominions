require 'rails_helper'

describe "user access a list of bills for it's units" do
  it 'and are unauthenticated' do
    visit bills_path

    expect(current_path).to eq new_resident_session_path
    expect(page).to have_content 'Para continuar, faça login ou registre-se.'
  end
  it 'from the dashboard' do
    condo = create :condo
    resident = create(:resident, :with_residence, condo:)
    unit11 = resident.residence
    json_data = Rails.root.join('spec/support/json/five_bills.json').read
    fake_response = double('faraday_response', body: json_data, success?: true)
    allow(Faraday).to receive(:get).with("http://localhost:4000/api/v1/units/#{unit11.id}/bills").and_return(fake_response)

    login_as resident, scope: :resident
    visit condo_path condo
    click_on 'Faturas em Aberto'
    within '#bills' do
      click_on 'ver mais'
    end

    expect(page).to have_content 'Minhas Faturas'
    expect(page).to have_content '10/09/2024'
    expect(page).to have_content 'R$ 50,00'
    expect(page).to have_content '10/07/2024'
    expect(page).to have_content 'R$ 10,00'
    expect(page).to have_content '10/05/2024'
    expect(page).to have_content 'R$ 30,00'
    expect(page).to have_content '10/03/2024'
    expect(page).to have_content 'R$ 25,64'
    expect(page).to have_content '10/02/2024'
    expect(page).to have_content 'R$ 12,34'
  end

  it "and there's no data" do
    condo = create :condo
    resident = create(:resident, :with_residence, condo:)
    unit11 = resident.residence
    json_data = Rails.root.join('spec/support/json/empty_bills.json').read
    fake_response = double('faraday_response', body: json_data, success?: true)
    allow(Faraday).to receive(:get).with("http://localhost:4000/api/v1/units/#{unit11.id}/bills").and_return(fake_response)

    login_as resident, scope: :resident
    visit bills_path

    expect(page).to have_content 'Minhas Faturas'
    expect(page).to have_content 'Não há faturas em aberto'
  end

  it "and there's an error due to connection lost" do
    condo = create :condo
    resident = create(:resident, :with_residence, condo:)
    allow(Faraday).to receive(:get).and_raise(Faraday::ConnectionFailed)

    login_as resident, scope: :resident
    visit bills_path

    expect(page).to have_content 'Não foi possível conectar no servidor do PagueAluguel'
    expect(current_path).to eq root_path
  end
end
