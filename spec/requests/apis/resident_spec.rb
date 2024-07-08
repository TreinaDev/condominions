require 'rails_helper'

describe 'Resident API' do
  context 'GET /api/v1/check_registration_number?' do
    it 'successfully and is an owner' do
      resident = create(:resident, registration_number: '076.550.640-83', resident_type: :owner)

      get "/api/v1/check_registration_number?registration_number=#{resident.registration_number}"

      expect(response).to have_http_status :ok
      expect(response.content_type).to include 'application/json'
      expect(response.parsed_body['resident_type']).to eq 'owner'
    end

    it 'successfully and is a tenant' do
      resident = create(:resident, registration_number: '076.550.640-83', resident_type: :tenant)

      get "/api/v1/check_registration_number?registration_number=#{resident.registration_number}"

      expect(response).to have_http_status :ok
      expect(response.content_type).to include 'application/json'
      expect(response.parsed_body['resident_type']).to eq 'tenant'
    end

    it "successfully and there's no match on the database" do
      registration_number = '076.550.640-83'
      get "/api/v1/check_registration_number?registration_number=#{registration_number}"

      expect(response).to have_http_status :ok
      expect(response.content_type).to include 'application/json'
      expect(response.parsed_body['resident_type']).to eq 'inexistent'
    end

    it "and fail if there's an internal server error" do
    end
  end
end
