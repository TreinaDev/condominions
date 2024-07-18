require 'rails_helper'

describe 'Manager registers superintendent' do
  context 'GET /condos/:condo_id/superintendents/new' do
    it 'must be authenticated to register an superintendent' do
      condo = create :condo, name: 'Condomínio X'
      tower = create(:tower, condo:)
      unit11 = tower.floors.first.units.first
      resident = create :resident, full_name: 'Dona Alvara', residence: unit11, email: 'alvara@email.com'
      superintendent = create(:superintendent, condo:, tenant: resident, start_date: Time.zone.today,
                                               end_date: Time.zone.today >> 2)

      get edit_condo_superintendent_path(condo, superintendent)

      expect(response).to redirect_to new_manager_session_path
    end

    it 'must be authenticated as condo manager to register a superintendent' do
      condo_manager = create :manager, is_super: false
      condo = create :condo, name: 'Condomínio X'
      tower = create(:tower, condo:)
      unit11 = tower.floors.first.units.first
      resident = create :resident, full_name: 'Dona Alvara', residence: unit11, email: 'alvara@email.com'
      superintendent = create(:superintendent, condo:, tenant: resident, start_date: Time.zone.today,
                                               end_date: Time.zone.today >> 2)

      login_as condo_manager, scope: :manager

      get edit_condo_superintendent_path(condo, superintendent)

      expect(response).to redirect_to root_path
    end

    it 'must be authenticated as manager' do
      condo = create :condo, name: 'Condomínio X'
      tower = create(:tower, condo:)
      unit11 = tower.floors.first.units.first
      resident = create :resident, full_name: 'Dona Alvara', residence: unit11, email: 'alvara@email.com'
      superintendent = create(:superintendent, condo:, tenant: resident, start_date: Time.zone.today,
                                               end_date: Time.zone.today >> 2)

      login_as resident, scope: :resident

      get edit_condo_superintendent_path(condo, superintendent)

      expect(response).to redirect_to root_path
    end
  end

  context 'patch /condos/:condo_id/superintendents' do
    it 'must be authenticated to register an superintendent' do
      condo = create :condo, name: 'Condomínio X'
      tower = create(:tower, condo:)
      unit11 = tower.floors.first.units.first
      unit12 = tower.floors.first.units[1]
      resident = create :resident, full_name: 'Dona Alvara', residence: unit11, email: 'alvara@email.com'
      resident2 = create :resident, full_name: 'Havana Silva', residence: unit12, email: 'havana@email.com'
      superintendent = create(:superintendent, condo:, tenant: resident, start_date: Time.zone.today,
                                               end_date: Time.zone.today >> 2)

      params = { superintendent: { tenant_id: resident2.id }, condo_id: condo.id }

      patch(condo_superintendent_path(condo, superintendent), params:)

      expect(response).to redirect_to new_manager_session_path
      expect(Superintendent.last.tenant).not_to eq resident2
    end

    it 'must be authenticated as condo manager to register a superintendent' do
      condo = create :condo, name: 'Condomínio X'
      tower = create(:tower, condo:)
      unit11 = tower.floors.first.units.first
      unit12 = tower.floors.first.units[1]
      resident = create :resident, full_name: 'Dona Alvara', residence: unit11, email: 'alvara@email.com'
      resident2 = create :resident, full_name: 'Havana Silva', residence: unit12, email: 'havana@email.com'
      superintendent = create(:superintendent, condo:, tenant: resident, start_date: Time.zone.today,
                                               end_date: Time.zone.today >> 2)

      condo_manager = create :manager, is_super: false
      login_as condo_manager, scope: :manager

      params = { superintendent: { tenant_id: resident2.id }, condo_id: condo.id }

      patch(condo_superintendent_path(condo, superintendent), params:)

      expect(response).to redirect_to root_path
      expect(Superintendent.last.tenant).not_to eq resident2
    end

    it 'must be authenticated as manager' do
      condo = create :condo, name: 'Condomínio X'
      tower = create(:tower, condo:)
      unit11 = tower.floors.first.units.first
      unit12 = tower.floors.first.units[1]
      resident = create :resident, full_name: 'Dona Alvara', residence: unit11, email: 'alvara@email.com'
      resident2 = create :resident, full_name: 'Havana Silva', residence: unit12, email: 'havana@email.com'
      superintendent = create(:superintendent, condo:, tenant: resident, start_date: Time.zone.today,
                                               end_date: Time.zone.today >> 2)

      login_as resident, scope: :resident

      params = { superintendent: { tenant_id: resident2.id }, condo_id: condo.id }

      patch(condo_superintendent_path(condo, superintendent), params:)

      expect(response).to redirect_to root_path
      expect(Superintendent.last.tenant).not_to eq resident2
    end
  end
end
