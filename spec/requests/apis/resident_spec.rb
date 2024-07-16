require 'rails_helper'

describe 'Resident API' do
  context 'GET /api/v1/check_owner?registration_number=' do
    it 'and resident exists' do
      resident = create(:resident, registration_number: '076.550.640-83')

      get "/api/v1/check_owner?registration_number=#{resident.registration_number}"

      expect(response).to have_http_status :ok
    end

    it "successfully and there's no match on the database" do
      get '/api/v1/check_owner?registration_number=076.550.640-83'

      expect(response).to have_http_status :not_found
    end

    it 'and fail if the registration number is invalid' do
      get '/api/v1/check_owner?registration_number=111.111.111-11'

      expect(response).to have_http_status :precondition_failed
    end

    it 'and returns 500 if internal error' do
      resident = create(:resident, registration_number: '076.550.640-83')
      allow(Resident).to receive(:find_by).and_raise ActiveRecord::ActiveRecordError

      get "/api/v1/check_owner?registration_number=#{resident.registration_number}"

      expect(response).to have_http_status :internal_server_error
    end
  end

  context 'GET /api/v1/get_tenant_residence?registration_number=' do
    it 'and tenant exists with residence' do
      condo = create :condo, name: 'Belas Paisagens'
      tower = create :tower, 'condo' => condo, name: 'Torre Norte', floor_quantity: 2, units_per_floor: 2
      unit_type = create :unit_type, description: 'Duplex com varanda', metreage: '145.54'
      unit11 = tower.floors[0].units[0]
      unit11.update(unit_type:)
      resident = create(:resident,
                        registration_number: '076.550.640-83',
                        full_name: 'Roberto dos Santos',
                        residence: unit11)
      owner = create(:resident,
                     registration_number: '734.706.130-01',
                     email: 'owner@email.com',
                     properties: [unit11])

      get "/api/v1/get_tenant_residence?registration_number=#{resident.registration_number}"

      expect(response).to have_http_status :ok
      expect(response.parsed_body['resident']['name']).to include 'Roberto dos Santos'
      expect(response.parsed_body['resident']['tenant_id']).to eq resident.id
      expect(response.parsed_body['resident']['residence']['id']).to eq unit11.id
      expect(response.parsed_body['resident']['residence']['area']).to include '145.54'
      expect(response.parsed_body['resident']['residence']['floor']).to eq tower.floors[0].identifier
      expect(response.parsed_body['resident']['residence']['number']).to include '11'
      expect(response.parsed_body['resident']['residence']['unit_type_id']).to eq unit_type.id
      expect(response.parsed_body['resident']['residence']['condo_id']).to eq 1
      expect(response.parsed_body['resident']['residence']['condo_name']).to include 'Belas Paisagens'
      expect(response.parsed_body['resident']['residence']['owner_id']).to eq owner.id
      expect(response.parsed_body['resident']['residence']['description']).to include 'Duplex com varanda'
    end

    it 'and tenant exists but has no residence' do
      resident = create(:resident)

      get "/api/v1/get_tenant_residence?registration_number=#{resident.registration_number}"

      expect(response).to have_http_status :not_found
    end

    it 'and tenant does not exists' do
      get '/api/v1/get_tenant_residence?registration_number=076.550.640-83'

      expect(response).to have_http_status :not_found
    end

    it 'and the registration number is invalid' do
      get '/api/v1/get_tenant_residence?registration_number=111.111.111-11'

      expect(response).to have_http_status :precondition_failed
    end

    it 'and returns 500 if internal error' do
      resident = create(:resident, registration_number: '076.550.640-83')
      allow(Resident).to receive(:find_by).and_raise ActiveRecord::ActiveRecordError

      get "/api/v1/get_tenant_residence?registration_number=#{resident.registration_number}"

      expect(response).to have_http_status :internal_server_error
    end
  end
end
