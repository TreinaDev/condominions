require 'rails_helper'

describe 'Unit Types' do
  context 'GET /unit_types' do
    it 'must be authenticated as Super Manager or condo associated' do
      manager = create :manager, is_super: false
      condo = create :condo
      unit_type = create(:unit_type, condo:)

      login_as manager, scope: :manager
      get unit_type_path unit_type

      expect(response).to redirect_to root_path
    end
  end

  context 'POST /condo_unit_types' do
    it 'and is not authenticated' do
      condo = create :condo

      post condo_unit_types_path condo, params: { unit_type: { description: 'Apartamento Duplex',
                                                               metreage: 60, fraction: 3 } }

      expect(response).to redirect_to new_manager_session_path
      expect(UnitType.count).to eq 0
    end

    it 'and he is not associated or is not a super' do
      manager = create :manager, is_super: false
      condo = create :condo

      login_as manager, scope: :manager
      post condo_unit_types_path condo, params: { unit_type: { description: 'Apartamento Duplex',
                                                               metreage: 60, fraction: 3 } }

      expect(response).to redirect_to root_path
      expect(UnitType.count).to eq 0
    end
  end

  context 'PATCH /unit_types' do
    it 'and is not authenticated' do
      unit_type = create :unit_type, description: 'Apartamento Duplex'

      patch unit_type_path unit_type, params: { unit_type: { description: 'Apartamento Triplex' } }
      unit_type.reload

      expect(response).to redirect_to new_manager_session_path
      expect(unit_type.description).to eq 'Apartamento Duplex'
    end

    it 'and he´s not associated or is not a super' do
      manager = create :manager, is_super: false
      condo = create :condo
      unit_type = create :unit_type, condo:, description: 'Apartamento Duplex'

      login_as manager, scope: :manager
      patch unit_type_path unit_type, params: { unit_type: { description: 'Apartamento Triplex' } }
      unit_type.reload

      expect(response).to redirect_to root_path
      expect(unit_type.description).to eq 'Apartamento Duplex'
    end
  end
end
