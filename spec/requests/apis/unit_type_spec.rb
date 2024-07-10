require 'rails_helper'

describe 'Unit Type API' do
  context 'GET /api/v1/condos/{id}/unit_types' do
    it 'successfully' do
      first_condo = create :condo
      second_condo = create :condo

      first_unit_type = create :unit_type,
                               description: 'Apartamento de 1 quarto',
                               metreage: 50.55,
                               fraction: 2,
                               condo: first_condo

      second_unit_type = create :unit_type,
                                description: 'Apartamento de 2 quartos',
                                condo: second_condo

      third_unit_type = create :unit_type,
                               description: 'Apartamento de 3 quartos',
                               metreage: 90,
                               fraction: 4,
                               condo: first_condo

      first_tower = create :tower, floor_quantity: 2,
                                   units_per_floor: 2,
                                   condo: first_condo

      second_tower = create :tower,
                            floor_quantity: 3,
                            units_per_floor: 2,
                            condo: second_condo

      third_tower = create :tower,
                           floor_quantity: 2,
                           units_per_floor: 3,
                           condo: first_condo

      first_tower.floors.each do |floor|
        floor.units[0].update unit_type: first_unit_type
        floor.units[1].update unit_type: third_unit_type
      end

      second_tower.floors.each do |floor|
        floor.units[0].update unit_type: second_unit_type
        floor.units[1].update unit_type: second_unit_type
      end

      third_tower.floors.each do |floor|
        floor.units[0].update unit_type: third_unit_type
        floor.units[1].update unit_type: third_unit_type
        floor.units[2].update unit_type: first_unit_type
      end

      get '/api/v1/condos/1/unit_types'

      expect(response).to have_http_status :ok
      expect(response.parsed_body[0]['created_at']).not_to be_present
      expect(response.parsed_body[0]['updated_at']).not_to be_present
      expect(response.parsed_body.count).to eq 2

      expect(response.parsed_body[0]['id']).to eq 1
      expect(response.parsed_body[0]['description']).to eq 'Apartamento de 1 quarto'
      expect(response.parsed_body[0]['metreage']).to eq '50.55'
      expect(response.parsed_body[0]['fraction']).to eq '2.0'
      expect(response.parsed_body[0]['unit_ids'].count).to eq 4

      expect(response.parsed_body[1]['id']).to eq 3
      expect(response.parsed_body[1]['description']).to eq 'Apartamento de 3 quartos'
      expect(response.parsed_body[1]['metreage']).to eq '90.0'
      expect(response.parsed_body[1]['fraction']).to eq '4.0'
      expect(response.parsed_body[1]['unit_ids'].count).to eq 6
    end

    it "and there's no unit types" do
      create :condo

      get '/api/v1/condos/1/unit_types'

      expect(response).to have_http_status :ok
      expect(response.parsed_body).to be_empty
    end

    it 'and returns not found if condo is not found' do
      get '/api/v1/condos/999999999/unit_types'

      expect(response).to have_http_status :not_found
    end

    it "and fail if there's an internal server error" do
      create :condo
      allow(UnitType).to receive(:all).and_raise ActiveRecord::ActiveRecordError

      get '/api/v1/condos/1/unit_types'

      expect(response).to have_http_status :internal_server_error
    end
  end
end
