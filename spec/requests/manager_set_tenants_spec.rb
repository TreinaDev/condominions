require 'rails_helper'

describe 'Manager sets tenants in register' do
  context 'POST /residents/:resident_id/tenants' do
    it 'and is not authenticated' do
      resident = create(:resident, full_name: 'Adroaldo Silva')
      post resident_tenants_path(resident), params: { floor_id: '15' }

      expect(response).to redirect_to new_manager_session_path
      expect(flash[:alert]).to eq 'Para continuar, faça login ou registre-se.'
    end

    it 'and hes not authenticated as manager' do
      create :tower
      resident = create :resident

      login_as resident, scope: :resident

      post resident_tenants_path(resident), params: {
        resident: { tower_id: '1', floor: '1', unit: '1' }, commit: 'Atualizar Morador'
      }

      expect(response).to redirect_to(root_path)
      expect(resident.residence).to eq nil
    end

    it 'and hes not associated' do
      manager = create :manager, is_super: false
      tower = create :tower
      unit11 = tower.floors[0].units[0]
      resident = create :resident
      resident.properties << unit11

      login_as manager, scope: :manager

      post resident_tenants_path(resident), params: {
        resident: { tower_id: '1', floor: '1', unit: '1' }, commit: 'Atualizar Morador'
      }

      expect(response).to redirect_to(root_path)
      expect(resident.residence).to eq nil
    end
  end
end
