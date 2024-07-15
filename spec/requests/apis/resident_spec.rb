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
end
