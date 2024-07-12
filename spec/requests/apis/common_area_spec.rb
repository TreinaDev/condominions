require 'rails_helper'

describe 'Common Area API' do
  context 'GET /api/v1/condos/{id}/common_areas' do
    it 'successfully' do
      condo = create :condo
      first_common_area1 = create(:common_area, name: 'Piscina', description: 'Para adultos e crianças',
                                                max_occupancy: 50, rules: 'Só pode usar até as 22 hrs', condo:)
      second_common_area2 = create(:common_area, name: 'Salão de Festas', description: 'Salão para vários eventos',
                                                 max_occupancy: 100, rules: 'Se sujar limpe', condo:)

      get "/api/v1/condos/#{condo.id}/common_areas"

      expect(response).to have_http_status :ok
      expect(response.parsed_body.count).to eq 1

      expect(response.parsed_body['common_areas'][0]['id']).to eq first_common_area1.id
      expect(response.parsed_body['common_areas'][0]['name']).to eq 'Piscina'
      expect(response.parsed_body['common_areas'][0]['description']).to eq 'Para adultos e crianças'

      expect(response.parsed_body['common_areas'][1]['id']).to eq second_common_area2.id
      expect(response.parsed_body['common_areas'][1]['name']).to eq 'Salão de Festas'
      expect(response.parsed_body['common_areas'][1]['description']).to eq 'Salão para vários eventos'
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

      allow(Condo).to receive(:find_by).and_return(condo)
      allow(condo.common_areas).to receive(:order).and_raise ActiveRecord::ActiveRecordError

      get "/api/v1/condos/#{condo.id}/common_areas"

      expect(response).to have_http_status :internal_server_error
    end
  end

  context 'GET /api/v1/common_areas/{id}' do
    it 'successfully' do
      condo = create :condo
      common_area = create(:common_area, name: 'Piscina', description: 'Para adultos e crianças',
                                         max_occupancy: 50, rules: 'Só pode usar até as 22 hrs', condo:)

      get "/api/v1/common_areas/#{common_area.id}"

      expect(response).to have_http_status :ok
      expect(response.parsed_body['condo_id']).to eq condo.id
      expect(response.parsed_body['name']).to eq 'Piscina'
      expect(response.parsed_body['description']).to eq 'Para adultos e crianças'
      expect(response.parsed_body['max_occupancy']).to eq 50
      expect(response.parsed_body['rules']).to eq 'Só pode usar até as 22 hrs'
    end

    it 'and returns not found if common area is not found' do
      get '/api/v1/common_areas/999999'

      expect(response).to have_http_status :not_found
    end

    it "and fail if there's an internal server error" do
      condo = create :condo
      common_area = create(:common_area, condo:)

      allow(CommonArea).to receive(:find_by).and_raise ActiveRecord::ActiveRecordError

      get "/api/v1/common_areas/#{common_area.id}"

      expect(response).to have_http_status :internal_server_error
    end
  end
end
