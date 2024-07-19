require 'rails_helper'

describe 'user access the show bill page' do
  it 'and are unauthenticated' do
    external_server_bill_id = 1
    visit bill_path external_server_bill_id

    expect(current_path).to eq new_resident_session_path
    expect(page).to have_content 'Para continuar, faça login ou registre-se.'
  end

  it 'and sees all details' do
    condo = create :condo
    resident = create(:resident, :with_residence, condo:)
    unit11 = resident.residence
    json_data_list = Rails.root.join('spec/support/json/five_bills.json').read
    fake_response_list = double('faraday_response', body: json_data_list, success?: true)
    allow(Faraday).to receive(:get).with("http://localhost:4000/api/v1/units/#{unit11.id}/bills").and_return(fake_response_list)

    first_bill_id_from_five_json = 11
    json_data_details = Rails.root.join('spec/support/json/bill_1_details.json').read
    fake_response_details = double('faraday_response', body: json_data_details, success?: true)
    allow(Faraday).to receive(:get).with("http://localhost:4000/api/v1/bills/#{first_bill_id_from_five_json}").and_return(fake_response_details)

    login_as resident, scope: :resident
    visit condo_path condo
    click_on 'Faturas em Aberto'
    within(:css, '.accordion-bills .accordion-bill:nth-of-type(1)') do
      click_on 'Detalhes'
    end

    expect(page).to have_content 'Minha Fatura'
  end

  it "and there's no data for bill" do
    condo = create :condo
    resident = create(:resident, :with_residence, condo:)
    unit11 = resident.residence
    json_data_list = Rails.root.join('spec/support/json/five_bills.json').read
    fake_response_list = double('faraday_response', body: json_data_list, success?: true)
    allow(Faraday).to receive(:get).with("http://localhost:4000/api/v1/units/#{unit11.id}/bills").and_return(fake_response_list)

    first_bill_id_from_five_json = 11
    json_data_details = Rails.root.join('spec/support/json/empty_bills.json').read
    fake_response_details = double('faraday_response', body: json_data_details, success?: false, status: 404)
    allow(Faraday).to receive(:get).with("http://localhost:4000/api/v1/bills/#{first_bill_id_from_five_json}").and_return(fake_response_details)

    login_as resident, scope: :resident
    visit bill_path first_bill_id_from_five_json

    expect(current_path).to eq bills_path
    expect(page).to have_content 'Fatura não encontrada'
  end

  it "and there's an external error" do
    condo = create :condo
    resident = create(:resident, :with_residence, condo:)
    allow(Faraday).to receive(:get).and_raise(Faraday::ConnectionFailed)

    login_as resident, scope: :resident
    visit bills_path

    expect(page).to have_content 'Não foi possível conectar no servidor do PagueAluguel'
    expect(current_path).to eq root_path
  end
end
