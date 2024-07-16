require 'rails_helper'

describe 'Units API' do
  context 'GET /api/v1/condos/{id}/units' do
    it 'successfully' do
      condo = create :condo
      first_tower = create :tower, condo:, floor_quantity: 2, units_per_floor: 2
      second_tower = create :tower, condo:, floor_quantity: 3, units_per_floor: 2
      first_unit_type = create(:unit_type, description: 'Duplex com varanda', condo:)
      second_unit_type = create(:unit_type, description: 'Apartamento 1 quarto', condo:)

      first_tower.floors.each do |floor|
        floor.units[0].update unit_type: first_unit_type
        floor.units[1].update unit_type: second_unit_type
      end

      second_tower.floors.each do |floor|
        floor.units[0].update unit_type: second_unit_type
        floor.units[1].update unit_type: second_unit_type
      end

      unit_ids = first_tower.floors.flat_map { |floor| floor.units.pluck(:id) } +
                 second_tower.floors.flat_map { |floor| floor.units.pluck(:id) }

      get "/api/v1/condos/#{condo.id}/units"

      expect(response).to have_http_status :ok
      expect(response.parsed_body['unit_ids'].count).to eq unit_ids.count
      expect(response.parsed_body['unit_ids']).to match_array unit_ids
    end

    it 'and there`s no units' do
      condo = create :condo

      get "/api/v1/condos/#{condo.id}/units"

      expect(response).to have_http_status :ok
      expect(response.parsed_body['unit_ids']).to be_empty
    end

    it 'and returns not found if condo is not found' do
      get '/api/v1/condos/999999999/units'

      expect(response).to have_http_status :not_found
    end

    it 'and fail if there`s an internal server error' do
      condo = create :condo
      allow(Condo).to receive(:find).and_raise(ActiveRecord::ActiveRecordError)

      get "/api/v1/condos/#{condo.id}/units"

      expect(response).to have_http_status(:internal_server_error)
    end
  end
end
