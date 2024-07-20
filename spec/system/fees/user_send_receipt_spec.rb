require 'rails_helper'

describe 'resident visit the details view from bill' do
  it 'and click a button to send receipt' do
    condo = create :condo
    resident = create(:resident, :with_residence, condo:)
    first_bill_id_from_five_json = 11
    json_data_details = Rails.root.join('spec/support/json/bill_1_details.json').read
    fake_response_details = double('faraday_response', body: json_data_details, success?: true)
    allow(Faraday).to receive(:get).with("http://localhost:4000/api/v1/bills/#{first_bill_id_from_five_json}").and_return(fake_response_details)

    login_as resident, scope: :resident
    visit bill_path first_bill_id_from_five_json

    click_on 'Enviar Comprovante'

    expect(current_path).to eq new_bill_bill_path first_bill_id_from_five_json
    expect(page).to have_content 'Comprovante de Pagamento'
  end

  it "and do not see the send button if the bill isn't pending" do
    condo = create :condo
    resident = create(:resident, :with_residence, condo:)
    second_bill_id_from_five_json = 1
    json_data_details = Rails.root.join('spec/support/json/bill_2_details.json').read
    fake_response_details = double('faraday_response', body: json_data_details, success?: true)
    allow(Faraday).to receive(:get).with("http://localhost:4000/api/v1/bills/#{second_bill_id_from_five_json}").and_return(fake_response_details)

    login_as resident, scope: :resident
    visit bill_path second_bill_id_from_five_json

    expect(page).not_to have_content 'Enviar Comprovante'
  end
end
