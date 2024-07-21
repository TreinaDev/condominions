require 'rails_helper'

describe 'Manager registers superintendent' do
  context 'GET /condos/:condo_id/superintendents/new' do
    it 'must be authenticated to register an superintendent' do
      condo = create :condo

      get new_condo_superintendent_path(condo)

      expect(response).to redirect_to new_manager_session_path
    end

    it 'must be authenticated as condo manager to register a superintendent' do
      condo_manager = create :manager, is_super: false
      condo = create :condo

      login_as condo_manager, scope: :manager

      get new_condo_superintendent_path(condo)

      expect(response).to redirect_to root_path
    end

    it 'must be authenticated as manager' do
      resident = create :resident
      condo = create :condo

      login_as resident, scope: :resident

      get new_condo_superintendent_path(condo)

      expect(response).to redirect_to root_path
    end
  end

  context 'POST /condos/:condo_id/superintendents' do
    it 'must be authenticated to register an superintendent' do
      condo = create :condo
      resident = create(:resident, :with_residence, condo:)

      params = { superintendent: { start_date: Time.zone.today, end_date: Time.zone.today >> 2,
                                   tenant_id: resident.id }, condo_id: condo.id }

      post(condo_superintendents_path(condo), params:)

      expect(response).to redirect_to new_manager_session_path
      expect(Superintendent.last).to eq nil
    end

    it 'must be authenticated as condo manager to register a superintendent' do
      condo = create :condo
      resident = create(:resident, :with_residence, condo:)
      condo_manager = create :manager, is_super: false

      login_as condo_manager, scope: :manager

      params = { superintendent: { start_date: Time.zone.today, end_date: Time.zone.today >> 2,
                                   tenant_id: resident.id }, condo_id: condo.id }

      post(condo_superintendents_path(condo), params:)

      expect(response).to redirect_to root_path
      expect(Superintendent.last).to eq nil
    end

    it 'must be authenticated as manager' do
      condo = create :condo
      resident = create(:resident, :with_residence, condo:)

      login_as resident, scope: :resident

      params = { superintendent: { start_date: Time.zone.today, end_date: Time.zone.today >> 2,
                                   tenant_id: resident.id }, condo_id: condo.id }

      post(condo_superintendents_path(condo), params:)

      expect(response).to redirect_to root_path
      expect(Superintendent.last).to eq nil
    end
  end
end
