require 'rails_helper'

describe 'Manager view condo full visitors list' do
  context 'GET /condos/:id/visitors/all' do
    it 'only if authenticated' do
      condo = create :condo

      get all_condo_visitors_path condo

      expect(response).to redirect_to new_manager_session_path
      expect(flash[:alert]).to eq 'Para continuar, faça login ou registre-se.'
    end

    it 'only if associated with the condo' do
      condo = create :condo
      manager = create :manager, is_super: false

      login_as manager, scope: :manager
      get all_condo_visitors_path condo

      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq 'Você não tem permissão para fazer isso'
    end

    it 'successfully if associated with the condo' do
      condo = create :condo
      manager = create :manager, is_super: false
      manager.condos << condo

      login_as manager, scope: :manager
      get all_condo_visitors_path condo

      expect(response).to have_http_status :ok
    end

    it 'and cannot be authenticated as resident' do
      condo = create :condo
      resident = create :resident

      login_as resident, scope: :resident
      get all_condo_visitors_path condo

      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq 'Você não possui autorização para essa ação'
    end
  end
end
