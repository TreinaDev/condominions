require 'rails_helper'

describe 'Unit API' do
  context 'GET /api/v1/units/:id' do
    it 'and return all details from an unit' do
      condo = create :condo, name: 'Belas Paisagens'
      tower = create :tower, 'condo' => condo, name: 'Torre Norte', floor_quantity: 2, units_per_floor: 2
      unit_type = create :unit_type, description: 'Duplex com varanda', metreage: '145.54'
      unit11 = tower.floors[0].units[0]
      unit11.update(unit_type:)
      resident = create :resident,
                        registration_number: '076.550.640-83',
                        full_name: 'Roberto dos Santos',
                        residence: unit11
      owner = create :resident,
                     registration_number: '734.706.130-01',
                     email: 'owner@email.com',
                     properties: [unit11]

      get '/api/v1/units/1'

      expect(response).to have_http_status :ok
      expect(response.parsed_body['id']).to eq unit11.id
      expect(response.parsed_body['area']).to include '145.54'
      expect(response.parsed_body['floor']).to eq tower.floors[0].identifier
      expect(response.parsed_body['number']).to eq unit11.short_identifier
      expect(response.parsed_body['condo_id']).to eq condo.id
      expect(response.parsed_body['condo_name']).to eq 'Belas Paisagens'
      expect(response.parsed_body['tenant_id']).to eq resident.id
      expect(response.parsed_body['owner_id']).to eq owner.id
      expect(response.parsed_body['description']).to eq 'Duplex com varanda'
    end
  end
end
