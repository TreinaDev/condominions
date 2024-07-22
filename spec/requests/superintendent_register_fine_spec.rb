require 'rails_helper'

describe 'Superintendent register fine' do
  context 'GET /condos/:condo_id/fines/new' do
    it 'and must be authenticated' do
      condo = create :condo, name: 'Condomínio X'

      get new_condo_fine_path(condo)

      expect(response).to redirect_to root_path
    end

    it 'and must be authenticated as a superintendent to access' do
      condo = create :condo, name: 'Condomínio X'
      tower = create(:tower, condo:)
      unit11 = tower.floors.first.units.first
      resident = create :resident, full_name: 'Dona Alvara', residence: unit11, email: 'alvara@email.com'

      login_as resident, scope: :resident

      get new_condo_fine_path(condo)

      expect(response).to redirect_to root_path
    end

    it 'and is authenticated as a manager' do
      condo = create :condo, name: 'Condomínio X'
      manager = create :manager

      login_as manager, scope: :manager

      get new_condo_fine_path(condo)

      expect(response).to redirect_to root_path
    end
  end

  context 'POST /condos/:condo_id/fines' do
    it 'and must be authenticated' do
      condo = create :condo, name: 'Condomínio X'
      tower = create(:tower, condo:)
      unit11 = tower.floors.first.units.first
      create :resident, properties: [unit11]

      params = { single_charge: { tower_id: '1', floor: '1', unit: '1',
                                  description: 'Barulho dms', value_cents: '5000' }, condo_id: '1' }

      post(condo_fines_path(condo), params:)

      expect(response).to redirect_to root_path
      expect(SingleCharge.last).to eq nil
    end

    it 'and must be authenticated as a superintendent to access' do
      condo = create :condo, name: 'Condomínio X'
      tower = create(:tower, condo:)
      unit11 = tower.floors.first.units.first
      resident = create :resident, properties: [unit11]

      login_as resident, scope: :resident

      params = { single_charge: { tower_id: '1', floor: '1', unit: '1',
                                  description: 'Barulho dms', value_cents: '5000' }, condo_id: '1' }

      post(condo_fines_path(condo), params:)

      expect(response).to redirect_to root_path
      expect(SingleCharge.last).to eq nil
    end

    it 'and is authenticated as a manager' do
      condo = create :condo, name: 'Condomínio X'
      tower = create(:tower, condo:)
      unit11 = tower.floors.first.units.first
      create :resident, properties: [unit11]
      manager = create :manager

      login_as manager, scope: :manager

      params = { single_charge: { tower_id: '1', floor: '1', unit: '1',
                                  description: 'Barulho dms', value_cents: '5000' }, condo_id: '1' }

      post(condo_fines_path(condo), params:)

      expect(response).to redirect_to root_path
      expect(SingleCharge.last).to eq nil
    end

    it 'returns failure message if theres an external server error' do
      condo = create(:condo, name: 'Condomínio X')
      tower = create(:tower, condo:)
      unit11 = tower.floors.first.units.first
      resident = create(:resident, full_name: 'Dona Alvara', properties: [unit11], email: 'alvara@email.com')
      create(:superintendent, condo:, tenant: resident, start_date: Time.zone.today,
                              end_date: Time.zone.today >> 2)

      login_as resident, scope: :resident

      create_params = {
        description: 'Multa por barulho durante a madrugada',
        value_cents: 10_000,
        charge_type: :fine,
        issue_date: Time.zone.today,
        tower_id: tower.id,
        floor: unit11.floor.identifier,
        unit: unit11.identifier
      }

      single_charge =
        { single_charge: {
          description: 'Multa por barulho durante a madrugada',
          value_cents: 10_000,
          charge_type: :fine,
          issue_date: Time.zone.today,
          condo_id: condo.id,
          common_area_id: nil,
          unit_id: unit11.id
        } }

      fake_response = instance_double(Faraday::Response, status: 422, success?: false, body: {})
      fake_connection = instance_double(Faraday::Connection)

      allow(Faraday).to receive(:new).and_return(fake_connection)
      allow(fake_connection).to receive(:post)
        .with('/api/v1/single_charges/', single_charge.to_json, 'Content-Type' => 'application/json')
        .and_return(fake_response)

      post condo_fines_path(condo), params: { condo_id: condo.id, single_charge: create_params }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(flash.now[:alert]).to eq(I18n.t('alerts.single_charge.fine_not_created'))
      expect(SingleCharge.last).to eq nil
    end
  end
end
