require 'rails_helper'

describe 'Resident API' do
  context 'GET /api/v1/check_registration_number?registration_number=' do
    it 'successfully and is an owner' do
      resident = create(:resident, registration_number: '076.550.640-83', resident_type: :owner)

      get "/api/v1/check_registration_number?registration_number=#{resident.registration_number}"

      expect(response).to have_http_status :ok
      expect(response.content_type).to include 'application/json'
      expect(response.parsed_body['resident_type']).to eq 'owner'
      expect(response.parsed_body['unit_id']).to eq resident.unit_id
    end

    it 'successfully and is a tenant' do
      resident = create(:resident, registration_number: '076.550.640-83', resident_type: :tenant)

      get "/api/v1/check_registration_number?registration_number=#{resident.registration_number}"

      expect(response).to have_http_status :ok
      expect(response.content_type).to include 'application/json'
      expect(response.parsed_body['resident_type']).to eq 'tenant'
      expect(response.parsed_body['unit_id']).to eq resident.unit_id
    end

    it "successfully and there's no match on the database" do
      get '/api/v1/check_registration_number?registration_number=076.550.640-83'

      expect(response).to have_http_status :not_found
      expect(response.content_type).to include 'application/json'
      expect(response.parsed_body['resident_type']).to eq 'inexistent'
      expect(response.parsed_body['unit_id']).to eq 'nil'
    end

    it 'and fail if the registration number is invalid' do
      get '/api/v1/check_registration_number?registration_number=111.111.111-11'

      expect(response).to have_http_status :precondition_failed
      expect(response.content_type).to include 'application/json'
      expect(response.parsed_body['error']).to eq 'invalid registration number'
    end

    it 'and returns 500 if internal error' do
      resident = create(:resident, registration_number: '076.550.640-83', resident_type: :owner)
      allow(Resident).to receive(:find_by).and_raise ActiveRecord::ActiveRecordError

      get "/api/v1/check_registration_number?registration_number=#{resident.registration_number}"

      expect(response).to have_http_status :internal_server_error
    end
  end
end
