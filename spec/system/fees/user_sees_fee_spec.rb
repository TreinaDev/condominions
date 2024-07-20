require 'rails_helper'

describe 'user access condo show' do
  it 'and see fees on dashboard' do
    condo = create :condo
    resident = create(:resident, :with_residence, condo:)
    unit11 = resident.residence
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

  it 'and do not see more than 3 ordered by more recent' do
    condo = create :condo
    resident = create(:resident, :with_residence, condo:)
    unit11 = resident.residence
    json_data = Rails.root.join('spec/support/json/five_bills.json').read
    fake_response = double('faraday_response', body: json_data, success?: true)
    allow(Faraday).to receive(:get).with("http://localhost:4000/api/v1/units/#{unit11.id}/bills").and_return(fake_response)

    login_as resident, scope: :resident

    visit condo_path condo
    click_on 'Faturas em Aberto'

    expect(page).to have_content 'Faturas em Aberto'
    expect(page).to have_content 'Vencimento: 10/09/2024'
    expect(page).to have_content 'Valor: R$ 50,00'
    expect(page).to have_content 'Vencimento: 10/07/2024'
    expect(page).to have_content 'Valor: R$ 10,00'
    expect(page).to have_content 'Vencimento: 10/05/2024'
    expect(page).to have_content 'Valor: R$ 30,00'
    within '#bills' do
      expect(page).to have_content 'ver mais'
    end
    expect(page).not_to have_content 'Vencimento: 10/03/2024'
    expect(page).not_to have_content 'Valor: R$ 25,64'
    expect(page).not_to have_content 'Vencimento: 10/02/2024'
    expect(page).not_to have_content 'Valor: R$ 12,34'
  end

  it "and there's no data returned" do
    condo = create :condo
    resident = create(:resident, :with_residence, condo:)
    unit11 = resident.residence
    json_data = Rails.root.join('spec/support/json/empty_bills.json').read
    fake_response = double('faraday_response', body: json_data, success?: true)
    allow(Faraday).to receive(:get).with("http://localhost:4000/api/v1/units/#{unit11.id}/bills").and_return(fake_response)

    login_as resident, scope: :resident

    visit condo_path condo
    click_on 'Faturas em Aberto'

    expect(page).to have_content 'Não existem faturas em aberto.'
  end

  it 'and connection is lost with the external API' do
    condo = create :condo
    resident = create(:resident, :with_residence, condo:)
    allow(Faraday).to receive(:get).and_raise(Faraday::ConnectionFailed)

    login_as resident, scope: :resident

    visit condo_path condo
    click_on 'Faturas em Aberto'

    expect(page).to have_content 'Conexão perdida com o servidor do PagueAlugel.'
  end
end
