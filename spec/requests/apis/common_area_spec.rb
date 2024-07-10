require 'rails_helper'

describe 'Common Area API' do
  context 'GET /api/v1/condos/{id}/common_areas' do
    it 'successfully' do
      condo = create :condo
      common_area1 = create(:common_area, name: 'Piscina', description: 'Para adultos e crianças',
                                          max_occupancy: 50, rules: 'Só pode usar até as 22 hrs', condo:)
      common_area2 = create(:common_area, name: 'Salão de Festas', description: 'Salão para vários eventos',
                                          max_occupancy: 100, rules: 'Se sujar limpe', condo:)

      get "/api/v1/condos/#{condo.id}/common_areas"

      expect(response).to have_http_status :ok
      expect(response.parsed_body.count).to eq 2

      expect(response.parsed_body['condo_id']).to eq condo.id.to_s
      expect(response.parsed_body['common_areas'][0]['id']).to eq common_area1.id
      expect(response.parsed_body['common_areas'][0]['name']).to eq 'Piscina'
      expect(response.parsed_body['common_areas'][0]['description']).to eq 'Para adultos e crianças'
      expect(response.parsed_body['common_areas'][0]['max_occupancy']).to eq 50
      expect(response.parsed_body['common_areas'][0]['rules']).to eq 'Só pode usar até as 22 hrs'

      expect(response.parsed_body['common_areas'][1]['id']).to eq common_area2.id
      expect(response.parsed_body['common_areas'][1]['name']).to eq 'Salão de Festas'
      expect(response.parsed_body['common_areas'][1]['description']).to eq 'Salão para vários eventos'
      expect(response.parsed_body['common_areas'][1]['max_occupancy']).to eq 100
      expect(response.parsed_body['common_areas'][1]['rules']).to eq 'Se sujar limpe'
    end

    it "and there's no common areas" do
      condo = create :condo

      get "/api/v1/condos/#{condo.id}/common_areas"

      expect(response).to have_http_status :ok
      expect(response.parsed_body['common_areas']).to be_empty
    end

    it 'and returns not found if condo is not found' do
      get '/api/v1/condos/999999/common_areas'

      expect(response).to have_http_status :not_found
    end

    it "and fail if there's an internal server error" do
      condo = create :condo

      allow(CommonArea).to receive(:where).and_raise ActiveRecord::ActiveRecordError

      get "/api/v1/condos/#{condo.id}/common_areas"

      expect(response).to have_http_status :internal_server_error
    end
  end

  context 'GET /api/v1/condos/{id}/common_areas/{id}' do
    it 'successfully' do
      condo = create :condo
      common_area = create(:common_area, name: 'Piscina', description: 'Para adultos e crianças',
                                         max_occupancy: 50, rules: 'Só pode usar até as 22 hrs', condo:)

      get "/api/v1/condos/#{condo.id}/common_areas/#{common_area.id}"

      expect(response).to have_http_status :ok
      expect(response.parsed_body['id']).to eq common_area.id
      expect(response.parsed_body['name']).to eq 'Piscina'
      expect(response.parsed_body['description']).to eq 'Para adultos e crianças'
      expect(response.parsed_body['max_occupancy']).to eq 50
      expect(response.parsed_body['rules']).to eq 'Só pode usar até as 22 hrs'
    end

    it 'and returns not found if common area is not found' do
      condo = create :condo

      get "/api/v1/condos/#{condo.id}/common_areas/999999"

      expect(response).to have_http_status :not_found
    end

    it "and fail if there's an internal server error" do
      condo = create :condo
      common_area = create(:common_area, condo:)

      allow(CommonArea).to receive(:find_by).and_raise ActiveRecord::ActiveRecordError

      get "/api/v1/condos/#{condo.id}/common_areas/#{common_area.id}"

      expect(response).to have_http_status :internal_server_error
    end
  end
end
