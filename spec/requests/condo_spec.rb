require 'rails_helper'

describe 'Manager' do
  context 'sees condo' do
    it 'and cannot see details from a condo that he`s not associated' do
      manager = create :manager, is_super: false
      condo = create :condo

      login_as manager, scope: :manager
      get condo_path condo

      expect(response).to redirect_to root_path
    end
  end

  context 'register condo' do
    it 'and is not authenticated' do
      post condos_path

      expect(response).to redirect_to new_manager_session_path
      expect(Condo.all).to eq []
    end

    it 'and must be authenticated as Super Manager' do
      manager = create :manager, is_super: false

      login_as manager, scope: :manager
      post condos_path

      expect(response).to redirect_to root_path
      expect(Condo.all).to eq []
    end
  end

  context 'edit condo' do
    it 'and is not authenticated' do
      condo = create :condo, name: 'Condomínio Criado'

      patch(condo_path(condo), params: { condo: { name: 'Condomínio Editado' } })

      expect(response).to redirect_to(new_manager_session_path)
      expect(condo.name).to eq 'Condomínio Criado'
    end

    it 'and must be associated to the condo' do
      condo_manager = create :manager, is_super: false
      other_manager = create :manager, is_super: false
      condo = create :condo, name: 'Condomínio Criado'
      condo.managers << condo_manager

      login_as other_manager, scope: :manager

      patch(condo_path(condo), params: { condo: { name: 'Condomínio Editado' } })
      condo.reload

      expect(response).to redirect_to root_path
      expect(condo.name).not_to eq 'Condomínio Editado'
    end
  end

  context 'delegate a manager' do
    it 'and must be authenticated as a Super Manager to access the form' do
      condo_manager = create :manager, is_super: false
      condo = create :condo, name: 'Condominio Criado'
      condo.managers << condo_manager

      login_as condo_manager, scope: :manager
      get add_manager_condo_path condo

      expect(response).to redirect_to root_path
    end

    it 'and must be authenticated as a Super Manager to delegate a manager to condo' do
      manager = create :manager, is_super: false
      other_manager = create :manager, is_super: false
      condo = create :condo, name: 'Condomínio Criado'

      login_as manager, scope: :manager
      post associate_manager_condo_path condo, params: { manager_id: other_manager.id }
      condo.reload

      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq 'Você não tem permissão para fazer isso'
      expect(condo.managers).not_to include other_manager
    end
  end
end
