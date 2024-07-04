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
      expect(response.parsed_body[0]['id']).to eq 1
      expect(response.parsed_body[0]['name']).to eq 'Condomínio A'
      expect(response.parsed_body[0]['address']['city']).to eq 'São Paulo'
      expect(response.parsed_body[0]['address']['state']).to eq 'SP'
      expect(response.parsed_body[1]['id']).to eq 2
      expect(response.parsed_body[1]['name']).to eq 'Condomínio B'
      expect(response.parsed_body[1]['address']['city']).to eq 'Xique-Xique'
      expect(response.parsed_body[1]['address']['state']).to eq 'BA'
    end
  end
end
