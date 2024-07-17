require 'rails_helper'

describe 'Manager set owner' do
  context 'DELETE /residents/:resident_id/owners/:id' do
    it 'and hes not authenticated' do
      unit = create :unit
      resident = create :resident, properties: [unit]

      delete resident_owner_path(resident, unit), params: { unit_id: unit.id }

      expect(response).to redirect_to(new_manager_session_path)
      expect(resident.properties).to include unit
    end

    it 'and hes not authenticated as manager' do
      unit = create :unit
      resident = create :resident, properties: [unit]

      login_as resident, scope: :resident
      delete resident_owner_path(resident, unit), params: { unit_id: unit.id }

      expect(response).to redirect_to(root_path)
      expect(resident.properties).to include unit
    end

    it 'and hes not associated' do
      manager = create :manager, is_super: false
      unit = create(:unit)
      resident = create :resident, properties: [unit]

      login_as manager, scope: :manager
      delete resident_owner_path(resident, unit), params: { unit_id: unit.id }

      expect(response).to redirect_to(root_path)
      expect(resident.properties).to include unit
    end
  end

  context 'POST /residents/:resident_id/owners' do
    it 'and hes not authenticated' do
      create :tower
      resident = create :resident

      post resident_owners_path(resident), params: {
        resident: { tower_id: '1', floor: '1', unit: '1' }, commit: 'Adicionar Propriedade'
      }

      expect(response).to redirect_to(new_manager_session_path)
      expect(resident.properties.empty?).to eq true
    end

    it 'and hes not authenticated as manager' do
      create :tower
      resident = create :resident

      login_as resident, scope: :resident

      post resident_owners_path(resident), params: {
        resident: { tower_id: '1', floor: '1', unit: '1' }, commit: 'Adicionar Propriedade'
      }

      expect(response).to redirect_to(root_path)
      expect(resident.properties.empty?).to eq true
    end

    it 'and hes not associated' do
      manager = create :manager, is_super: false
      create :tower
      resident = create :resident

      login_as manager, scope: :manager

      post resident_owners_path(resident), params: {
        resident: { tower_id: '1', floor: '1', unit: '1' }, commit: 'Adicionar Propriedade'
      }

      expect(response).to redirect_to(root_path)
      expect(resident.properties.empty?).to eq true
    end
  end
end
