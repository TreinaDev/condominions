require 'rails_helper'

describe 'Manager registers users' do
  context 'POST /managers' do
    it 'must be authenticated to register an administrator' do
      post managers_path, params: { manager: { full_name: 'João Carvalho', registration_number: '642.028.670-09',
                                               email: 'joao@email.com', password: 'password' } }

      expect(response).to redirect_to new_manager_session_path
      expect(flash[:alert]).to eq 'Para continuar, faça login ou registre-se.'
    end

    it 'must be authenticated as Super Manager to register a manager' do
      condo_manager = create :manager, is_super: false

      login_as condo_manager, scope: :manager
      post managers_path, params: { manager: { full_name: 'Julia Silva', registration_number: '642.028.670-09',
                                               email: 'julia@email.com', password: 'password' } }

      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq 'Você não tem permissão para fazer isso'
      expect(Manager.last.full_name).not_to eq 'Julia Silva'
    end
  end

  context 'POST /residents' do
    it 'must be authenticated to register a resident' do
      post residents_path, params: { resident: { full_name: 'Julia Silva' } }

      expect(response).to redirect_to new_manager_session_path
      expect(flash[:alert]).to eq 'Para continuar, faça login ou registre-se.'
    end
  end
end
