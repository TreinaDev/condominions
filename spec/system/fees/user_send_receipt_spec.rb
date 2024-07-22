require 'rails_helper'

describe 'resident visit the details view from bill' do
  before(:all) do
    @first_bill_id_from_five_json = 11
  end

  it 'and click a button to see the submition form' do
    condo = create :condo
    resident = create(:resident, :with_residence, condo:)
    json_data_details = Rails.root.join('spec/support/json/bill_1_details.json').read
    fake_response_details = double('faraday_response', body: json_data_details, success?: true)
    allow(Faraday).to receive(:get).with("http://localhost:4000/api/v1/bills/#{@first_bill_id_from_five_json}").and_return(fake_response_details)

    login_as resident, scope: :resident
    visit bill_path @first_bill_id_from_five_json

    click_on 'Enviar Comprovante'

    expect(current_path).to eq new_bill_receipt_path @first_bill_id_from_five_json
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

  it 'and visit form page unauthenticated' do
    visit new_bill_receipt_path @first_bill_id_from_five_json

    expect(current_path).to eq new_resident_session_path
    expect(page).to have_content 'Para continuar, faça login ou registre-se.'
  end

  it 'and successfully send the image to the external api' do
    condo = create :condo
    resident = create(:resident, :with_residence, condo:)
    json_data_details = Rails.root.join('spec/support/json/bill_1_details.json').read
    fake_response_details = double('faraday_response', body: json_data_details, success?: true)
    fake_response_open_bills = double('faraday_response', body: '{"bills":[]}', success?: true)
    fake_response_receipt = double('faraday_response', body: '{"message":"Comprovante recebido com sucesso."}',
                                                       success?: true)

    allow(Faraday).to receive(:get).with("http://localhost:4000/api/v1/units/#{resident.residence.id}/bills").and_return(fake_response_open_bills)
    allow(Faraday).to receive(:get).with("http://localhost:4000/api/v1/bills/#{@first_bill_id_from_five_json}").and_return(fake_response_details)
    allow(Faraday).to receive(:post).and_return(fake_response_receipt)

    login_as resident, scope: :resident
    visit bill_path @first_bill_id_from_five_json
    click_on 'Enviar Comprovante'

    attach_file 'image', Rails.root.join('spec/support/images/cupom-fiscal.jpg')
    click_on 'Enviar'

    expect(page).to have_content 'Comprovante enviado ao servidor do PagueAluguel'
    expect(current_path).to eq bills_path
  end

  it 'and fail to sends the image to the external api' do
    condo = create :condo
    resident = create(:resident, :with_residence, condo:)
    json_data_details = Rails.root.join('spec/support/json/bill_1_details.json').read
    fake_response_details = double('faraday_response', body: json_data_details, success?: true)
    fake_response_open_bills = double('faraday_response', body: '{"bills":[]}', success?: true)
    fake_response_receipt = double('faraday_response', body: '{"message":"Comprovante recebido com sucesso."}',
                                                       success?: false)

    allow(Faraday).to receive(:get).with("http://localhost:4000/api/v1/units/#{resident.residence.id}/bills").and_return(fake_response_open_bills)
    allow(Faraday).to receive(:get).with("http://localhost:4000/api/v1/bills/#{@first_bill_id_from_five_json}").and_return(fake_response_details)
    allow(Faraday).to receive(:post).and_return(fake_response_receipt)

    login_as resident, scope: :resident
    visit bill_path @first_bill_id_from_five_json
    click_on 'Enviar Comprovante'

    attach_file 'image', Rails.root.join('spec/support/images/cupom-fiscal.jpg')
    click_on 'Enviar'

    expect(page).to have_content 'Impossível enviar o comprovante ao servidor do PagueAluguel'
    expect(current_path).to eq bills_path
  end

  it 'and fail to sends the image to the external api because of missing image' do
    condo = create :condo
    resident = create(:resident, :with_residence, condo:)
    json_data_details = Rails.root.join('spec/support/json/bill_1_details.json').read
    fake_response_details = double('faraday_response', body: json_data_details, success?: true)
    fake_response_open_bills = double('faraday_response', body: '{"bills":[]}', success?: true)
    fake_response_receipt = double('faraday_response', body: '{"message":"Comprovante recebido com sucesso."}',
                                                       success?: true)

    allow(Faraday).to receive(:get).with("http://localhost:4000/api/v1/units/#{resident.residence.id}/bills").and_return(fake_response_open_bills)
    allow(Faraday).to receive(:get).with("http://localhost:4000/api/v1/bills/#{@first_bill_id_from_five_json}").and_return(fake_response_details)
    allow(Faraday).to receive(:post).and_return(fake_response_receipt)

    login_as resident, scope: :resident
    visit bill_path @first_bill_id_from_five_json
    click_on 'Enviar Comprovante'

    click_on 'Enviar'

    expect(page).to have_content 'Comprovante não pode ficar vazio'
    expect(current_path).to eq new_bill_receipt_path @first_bill_id_from_five_json
  end
end
