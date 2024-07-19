require 'rails_helper'

RSpec.describe FinesController, type: :controller do
  describe 'POST #create' do
    include Devise::Test::ControllerHelpers
    include Warden::Test::Helpers

    before do
      Warden.test_mode!
    end

    after do
      Warden.test_reset!
    end

    it 'successfully' do
      condo = create(:condo, name: 'Condomínio X')
      tower = create(:tower, condo:)
      unit11 = tower.floors.first.units.first
      resident = create(:resident, full_name: 'Dona Alvara', properties: [unit11], email: 'alvara@email.com')
      create(:superintendent, condo:, tenant: resident, start_date: Time.zone.today,
                              end_date: Time.zone.today >> 2)

      login_as resident, scope: :resident

      single_charge = {
        description: 'Multa por barulho durante a madrugada',
        value_cents: 10_000,
        charge_type: 'fine',
        unit_id: unit11.id
      }

      fake_response = instance_double(Faraday::Response, success?: true, body: { message: 'Success' }.to_json)
      fake_connection = instance_double(Faraday::Connection)

      allow(Faraday).to receive(:new).and_return(fake_connection)
      allow(fake_connection).to receive(:post).with('/api/v1/single_charges/', single_charge.to_json,
                                                    'Content-Type' => 'application/json').and_return(fake_response)

      post :create, params: { condo_id: condo.id, single_charge: }

      expect(response).to have_http_status(:found)
    end
  end
end
