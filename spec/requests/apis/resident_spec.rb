require 'rails_helper'

describe 'Resident API' do
  context 'GET /api/v1/check_owner?registration_number=' do
    it 'and resident exists' do
      create :resident, registration_number: '076.550.640-83'

      get '/api/v1/check_owner?registration_number=076.550.640-83'

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
      create :resident, registration_number: '076.550.640-83'
      allow(Resident).to receive(:find_by).and_raise ActiveRecord::ActiveRecordError

      get '/api/v1/check_owner?registration_number=076.550.640-83'

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
      resident = create :resident,
                        registration_number: '076.550.640-83',
                        full_name: 'Roberto dos Santos',
                        residence: unit11

      owner = create :resident, properties: [unit11]

      get '/api/v1/get_tenant_residence?registration_number=076.550.640-83'

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
      expect(response.parsed_body['resident']['residence']['tower_name']).to include 'Torre Norte'
    end

    it 'and tenant exists but has no residence' do
      create :resident, registration_number: '076.550.640-83'

      get '/api/v1/get_tenant_residence?registration_number=076.550.640-83'

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
      create :resident, registration_number: '076.550.640-83'
      allow(Resident).to receive(:find_by).and_raise ActiveRecord::ActiveRecordError

      get '/api/v1/get_tenant_residence?registration_number=076.550.640-83'

      expect(response).to have_http_status :internal_server_error
    end
  end

  context 'GET /api/v1/get_owner_properties?registration_number=' do
    it 'and owner exists with properties' do
      condo = create :condo, name: 'Belas Paisagens'
      tower = create :tower, 'condo' => condo, name: 'Torre Norte', floor_quantity: 2, units_per_floor: 2
      first_unit_type = create :unit_type, description: 'Duplex com varanda', metreage: '145.54'
      second_unit_type = create :unit_type, description: 'Triplex com sacada', metreage: '314.58'
      unit11 = tower.floors[0].units[0]
      unit12 = tower.floors[0].units[1]
      unit11.update unit_type: first_unit_type
      unit12.update unit_type: second_unit_type
      owner = create :resident,
                     registration_number: '734.706.130-01',
                     full_name: 'Roberto dos Santos',
                     properties: [unit11, unit12]

      resident = create :resident,
                        registration_number: '076.550.640-83',
                        full_name: 'Ednaldo Pereira',
                        residence: unit11

      get '/api/v1/get_owner_properties?registration_number=734.706.130-01'

      expect(response).to have_http_status :ok
      expect(response.parsed_body['resident']['name']).to include 'Roberto dos Santos'
      expect(response.parsed_body['resident']['owner_id']).to eq owner.id
      expect(response.parsed_body['resident']['properties'][0]['id']).to eq unit11.id
      expect(response.parsed_body['resident']['properties'][0]['area']).to include '145.54'
      expect(response.parsed_body['resident']['properties'][0]['floor']).to eq tower.floors[0].identifier
      expect(response.parsed_body['resident']['properties'][0]['number']).to include '11'
      expect(response.parsed_body['resident']['properties'][0]['unit_type_id']).to eq first_unit_type.id
      expect(response.parsed_body['resident']['properties'][0]['condo_id']).to eq 1
      expect(response.parsed_body['resident']['properties'][0]['condo_name']).to include 'Belas Paisagens'
      expect(response.parsed_body['resident']['properties'][0]['tenant_id']).to eq resident.id
      expect(response.parsed_body['resident']['properties'][0]['description']).to include 'Duplex com varanda'
      expect(response.parsed_body['resident']['properties'][0]['tower_name']).to include 'Torre Norte'

      expect(response.parsed_body['resident']['properties'][1]['id']).to eq unit12.id
      expect(response.parsed_body['resident']['properties'][1]['area']).to include '314.58'
      expect(response.parsed_body['resident']['properties'][1]['floor']).to eq tower.floors[0].identifier
      expect(response.parsed_body['resident']['properties'][1]['number']).to include '12'
      expect(response.parsed_body['resident']['properties'][1]['unit_type_id']).to eq second_unit_type.id
      expect(response.parsed_body['resident']['properties'][1]['condo_id']).to eq 1
      expect(response.parsed_body['resident']['properties'][1]['condo_name']).to include 'Belas Paisagens'
      expect(response.parsed_body['resident']['properties'][1]['tenant_id']).to eq nil
      expect(response.parsed_body['resident']['properties'][1]['tower_name']).to include 'Torre Norte'
    end

    it 'and owner exists but has no properties' do
      create :resident, registration_number: '734.706.130-01'

      get '/api/v1/get_owner_properties?registration_number=734.706.130-01'

      expect(response).to have_http_status :not_found
    end

    it 'and owner does not exists' do
      get '/api/v1/get_owner_properties?registration_number=076.550.640-83'

      expect(response).to have_http_status :not_found
    end

    it 'and the registration number is invalid' do
      get '/api/v1/get_owner_properties?registration_number=111.111.111-11'

      expect(response).to have_http_status :precondition_failed
    end

    it 'and returns 500 if internal error' do
      create :resident, registration_number: '076.550.640-83'
      allow(Resident).to receive(:find_by).and_raise ActiveRecord::ActiveRecordError

      get '/api/v1/get_owner_properties?registration_number=076.550.640-83'

      expect(response).to have_http_status :internal_server_error
    end
  end
end
