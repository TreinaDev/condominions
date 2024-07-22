require 'rails_helper'

describe 'Manager edits superintendent' do
  context 'GET /condos/:condo_id/superintendents/new' do
    it 'must be authenticated to edit an superintendent' do
      condo = create :condo, name: 'Condomínio X'
      resident = create(:resident, :with_residence, condo:)
      superintendent = create(:superintendent, condo:, tenant: resident, start_date: Date.current,
                                               end_date: Date.current >> 2)

      get edit_condo_superintendent_path(condo, superintendent)

      expect(response).to redirect_to new_manager_session_path
    end

    it 'must be authenticated as condo manager to edit a superintendent' do
      condo_manager = create :manager, is_super: false
      condo = create :condo, name: 'Condomínio X'
      resident = create(:resident, :with_residence, condo:)
      superintendent = create(:superintendent, condo:, tenant: resident, start_date: Date.current,
                                               end_date: Date.current >> 2)

      login_as condo_manager, scope: :manager

      get edit_condo_superintendent_path(condo, superintendent)

      expect(response).to redirect_to root_path
    end

    it 'must be authenticated as manager' do
      condo = create :condo, name: 'Condomínio X'
      resident = create(:resident, :with_residence, condo:)
      superintendent = create(:superintendent, condo:, tenant: resident, start_date: Date.current,
                                               end_date: Date.current >> 2)

      login_as resident, scope: :resident

      get edit_condo_superintendent_path(condo, superintendent)

      expect(response).to redirect_to root_path
    end
  end

  context 'patch /condos/:condo_id/superintendents' do
    it 'must be authenticated to edit an superintendent' do
      condo = create :condo, name: 'Condomínio X'
      resident = create(:resident, :with_residence, condo:)
      resident2 = create(:resident, :with_residence, email: 'Adrolado@email.com', condo:)
      superintendent = create(:superintendent, condo:, tenant: resident, start_date: Date.current,
                                               end_date: Date.current >> 2)

      params = { superintendent: { tenant_id: resident2.id }, condo_id: condo.id }

      patch(condo_superintendent_path(condo, superintendent), params:)

      expect(response).to redirect_to new_manager_session_path
      expect(Superintendent.last.tenant).not_to eq resident2
    end

    it 'must be authenticated as condo manager to edit a superintendent' do
      condo = create :condo, name: 'Condomínio X'
      resident = create(:resident, :with_residence, condo:)
      resident2 = create(:resident, :with_residence, email: 'Adrolado@email.com', condo:)
      superintendent = create(:superintendent, condo:, tenant: resident, start_date: Date.current,
                                               end_date: Date.current >> 2)

      condo_manager = create :manager, is_super: false
      login_as condo_manager, scope: :manager

      params = { superintendent: { tenant_id: resident2.id }, condo_id: condo.id }

      patch(condo_superintendent_path(condo, superintendent), params:)

      expect(response).to redirect_to root_path
      expect(Superintendent.last.tenant).not_to eq resident2
    end

    it 'must be authenticated as manager' do
      condo = create :condo, name: 'Condomínio X'
      resident = create(:resident, :with_residence, condo:)
      resident2 = create(:resident, :with_residence, email: 'Adrolado@email.com', condo:)
      superintendent = create(:superintendent, condo:, tenant: resident, start_date: Date.current,
                                               end_date: Date.current >> 2)

      login_as resident, scope: :resident

      params = { superintendent: { tenant_id: resident2.id }, condo_id: condo.id }

      patch(condo_superintendent_path(condo, superintendent), params:)

      expect(response).to redirect_to root_path
      expect(Superintendent.last.tenant).not_to eq resident2
    end
  end
end
