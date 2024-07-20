require 'rails_helper'

describe 'Common Areas' do
  context 'GET /common_areas' do
    it 'must be authenticated as Super Manager or condo associated' do
      condo_manager = create :manager, is_super: false
      condo = create :condo
      common_area = create(:common_area, condo:)

      login_as condo_manager, scope: :manager
      get common_area_path common_area

      expect(response).to redirect_to root_path
    end
  end

  context 'POST /common_areas' do
    it 'must be authenticated to register a common area' do
      condo = create :condo

      post condo_common_areas_path condo, params: { common_area: { name: 'Salão de Festas', max_occupancy: 100,
                                                                   description: 'Realize sua festa em nosso salão',
                                                                   rules: 'Não pode ser utilizado após as 22 horas' } }

      expect(response).to redirect_to new_manager_session_path
      expect(flash[:alert]).to eq 'Para continuar, faça login ou registre-se.'
    end

    it 'and he´s not associated or is not a super' do
      condo_manager = create :manager, is_super: false
      condo = create :condo

      login_as condo_manager, scope: :manager
      post condo_common_areas_path condo, params: { common_area: { name: 'Salão de Festas', max_occupancy: 100,
                                                                   description: 'Realize sua festa em nosso salão',
                                                                   rules: 'Não pode ser utilizado após as 22 horas' } }

      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq 'Você não tem permissão para fazer isso'
    end
  end

  context 'PATCH /common_areas' do
    it 'must be authenticated to edit a common area' do
      common_area = create :common_area

      patch common_area_path common_area, params: { common_area: { name: 'Área Comum Editada' } }
      common_area.reload

      expect(response).to redirect_to new_manager_session_path
      expect(common_area.name).not_to eq 'Área Comum Editada'
      expect(flash[:alert]).to eq 'Para continuar, faça login ou registre-se.'
    end

    it 'and he´s not associated or is not a super' do
      condo_manager = create :manager, is_super: false
      condo = create :condo
      common_area = create(:common_area, condo:)

      login_as condo_manager, scope: :manager
      patch common_area_path common_area, params: { common_area: { name: 'Área Comum Editada' } }
      common_area.reload

      expect(response).to redirect_to root_path
      expect(common_area.name).not_to eq 'Área Comum Editada'
      expect(flash[:alert]).to eq 'Você não tem permissão para fazer isso'
    end
  end
end
