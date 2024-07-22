require 'rails_helper'

describe 'Condo requests' do
  context 'POST /condos/:id/associate_manager' do
    it 'and condo manager is already associated' do
      manager = create :manager
      condo_manager = create :manager, is_super: false
      condo = create :condo
      condo.managers << condo_manager

      login_as manager, scope: :manager
      post associate_manager_condo_path(condo), params: { manager_id: condo_manager.id }

      expect(flash[:alert]).to eq 'Não foi possível adicionar o administrador'
    end
  end

  context 'GET /condos/:id/residents' do
    it 'and condo not found' do
      manager = create :manager

      login_as manager, scope: :manager
      get residents_condo_path(1)

      expect(response).to have_http_status :not_found
    end
  end
end
