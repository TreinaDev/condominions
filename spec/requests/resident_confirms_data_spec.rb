require 'rails_helper'

describe 'Resident confirms data' do
  context 'PATCH /residents/:id/confirm' do
    it 'must be authenticated to confirm data' do
      resident = create :resident, status: :not_confirmed

      patch resident_path(resident), params: { resident: { password: 'teste123' } }
      resident.reload

      expect(response).to redirect_to new_resident_session_path
      expect(flash[:alert]).to eq 'Para continuar, faça login ou registre-se.'
      expect(resident.not_confirmed?).to be true
    end

    it 'and cannot confirm another resident data' do
      first_resident = create :resident, status: :not_confirmed
      second_resident = create :resident, email: 'pedro@email.com', status: :not_confirmed

      login_as second_resident, scope: :resident
      patch resident_path(first_resident), params: { resident: { password: '123456' } }
      first_resident.reload

      expect(response).to redirect_to root_path
      expect(first_resident.not_confirmed?).to be true
    end

    it 'and manager cannot confirm resident data logged as manager' do
      resident = create :resident, status: :not_confirmed
      manager = create :manager

      login_as manager, scope: :manager
      patch resident_path(resident), params: { resident: { password: '123456' } }
      resident.reload

      expect(response).to redirect_to root_path
      expect(resident.not_confirmed?).to be true
    end
  end
end
