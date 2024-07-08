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
  context 'GET /api/v1/condos/:id' do
    it 'successfully' do
      address = create :address,
                       public_place: 'Travessa João Edimar',
                       number: '29',
                       neighborhood: 'João Eduardo II',
                       city: 'Rio Branco',
                       state: 'AC',
                       zip: '69911-520'

      create :condo, name: 'Condomínio A', address:, registration_number: '02.494.329/0001-81'
      create :condo, name: 'Condomínio B'

      get '/api/v1/condos/1'

      expect(response).to have_http_status :ok
      expect(response.parsed_body).not_to include 'Condomínio B'
      expect(response.parsed_body['name']).to include 'Condomínio A'
      expect(response.parsed_body['registration_number']).to include '02.494.329/0001-81'
      expect(response.parsed_body['address']['public_place']).to include 'Travessa João Edimar'
      expect(response.parsed_body['address']['number']).to include '29'
      expect(response.parsed_body['address']['neighborhood']).to include 'João Eduardo II'
      expect(response.parsed_body['address']['city']).to include 'Rio Branco'
      expect(response.parsed_body['address']['state']).to include 'AC'
      expect(response.parsed_body['address']['zip']).to include '69911-520'
      expect(response.parsed_body['created_at']).not_to be_present
      expect(response.parsed_body['updated_at']).not_to be_present
    end

    it 'and returns 404 if condo is not found' do
      get '/api/v1/condos/999999999'

      expect(response).to have_http_status :not_found
    end

    it 'and returns 500 if internal error' do
      create :condo
      allow(Condo).to receive(:find_by).and_raise ActiveRecord::ActiveRecordError

      get '/api/v1/condos/1'

      expect(response).to have_http_status :internal_server_error
    end
  end
end
