require 'rails_helper'

describe 'Manager registers users' do
  context 'POST /managers' do
    it 'must be authenticated to register an administrator' do
      post managers_path, params: { manager: { full_name: 'João Carvalho', registration_number: '012.345.678-01',
                                              email: 'joao@email.com', password: 'password' } }

      expect(response).to redirect_to(new_manager_session_path)
      expect(flash[:alert]).to eq 'Para continuar, faça login ou registre-se.'
    end
  end

  context 'POST /residents' do
    it 'must be authenticated to register a resident' do
      post residents_path, params: { resident: { full_name: 'Julia Silva' } }

      expect(response).to redirect_to(new_manager_session_path)
      expect(flash[:alert]).to eq 'Para continuar, faça login ou registre-se.'
    end
  end
end