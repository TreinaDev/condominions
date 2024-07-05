require 'rails_helper'

describe 'Condo API' do
  context 'GET /api/v1/condos' do
    it 'successfully' do
      first_address = create :address, city: 'São Paulo', state: 'SP'
      second_address = create :address, city: 'Xique-Xique', state: 'BA'
      create :condo, name: 'Condomínio A', address: first_address
      create :condo, name: 'Condomínio B', address: second_address

      get '/api/v1/condos'

      expect(response).to have_http_status :ok
      expect(response.parsed_body[0]['registration_number']).not_to be_present
      expect(response.parsed_body[0]['created_at']).not_to be_present
      expect(response.parsed_body[0]['updated_at']).not_to be_present
      expect(response.parsed_body[0]['id']).to eq 1
      expect(response.parsed_body[0]['name']).to eq 'Condomínio A'
      expect(response.parsed_body[0]['city']).to eq 'São Paulo'
      expect(response.parsed_body[0]['state']).to eq 'SP'
      expect(response.parsed_body[1]['id']).to eq 2
      expect(response.parsed_body[1]['name']).to eq 'Condomínio B'
      expect(response.parsed_body[1]['city']).to eq 'Xique-Xique'
      expect(response.parsed_body[1]['state']).to eq 'BA'
    end

    it 'and theres no condos' do
      get '/api/v1/condos'

      expect(response).to have_http_status :ok
      expect(response.parsed_body).to be_empty
    end

    it "and fail if there's an internal server error" do
      allow(Condo).to receive(:all).and_raise ActiveRecord::ActiveRecordError

      get '/api/v1/condos'

      expect(response.status).to eq 500
    end
  end
end
