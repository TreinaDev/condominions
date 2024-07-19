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
  end
end
