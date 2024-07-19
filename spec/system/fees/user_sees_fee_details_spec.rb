require 'rails_helper'

describe 'user access the show bill page' do
  it 'and are unauthenticated' do
    external_server_bill_id = 1
    visit bill_path external_server_bill_id

    expect(current_path).to eq new_resident_session_path
    expect(page).to have_content 'Para continuar, faça login ou registre-se.'
  end

  it 'and sees all details' do

  end

  it "and there's no data for bill" do

  end

  it "and there's an external error" do

  end
end