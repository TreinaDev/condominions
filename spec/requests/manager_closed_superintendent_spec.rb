require 'rails_helper'

describe 'Manager closed superintendent' do
  context 'delete /condos/:condo_id/superintendents/new' do
    it 'must be authenticated to closed an superintendent' do
      condo = create :condo
      superintendent = create :superintendent

      delete condo_superintendent_path(condo, superintendent)

      expect(response).to redirect_to root_path
      expect(Superintendent.last).not_to eq nil
    end

    it 'must be authenticated as condo manager to register a superintendent' do
      manager = create :manager, is_super: false
      condo = create :condo
      superintendent = create :superintendent

      login_as manager, scope: :manager

      delete condo_superintendent_path(condo, superintendent)

      expect(response).to redirect_to root_path
      expect(Superintendent.last).not_to eq nil
    end

    it 'must be authenticated as manager' do
      resident = create :resident
      condo = create :condo
      superintendent = create :superintendent

      login_as resident, scope: :resident

      delete condo_superintendent_path(condo, superintendent)

      expect(response).to redirect_to root_path
      expect(Superintendent.last).not_to eq nil
    end
  end
end
