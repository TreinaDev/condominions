require 'rails_helper'

describe 'Announcements' do
  context 'POST /announcements' do
    it 'must be authenticated to register an announcement' do
      condo = create :condo

      post condo_announcements_path condo, params: { announcement: { title: 'Novo Aviso' } }

      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq 'Você não possui autorização para essa ação'
    end

    it "and he's not associated or is not a super" do
      condo_manager = create :manager, is_super: false
      condo = create :condo

      login_as condo_manager, scope: :manager
      post condo_announcements_path condo, params: { announcement: { title: 'Novo Aviso' } }

      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq 'Você não possui autorização para essa ação'
    end
  end

  context 'PATCH /announcements' do
    it 'must be authenticated to edit an announcement' do
      condo = create :condo
      announcement = create(:announcement, condo:)

      patch announcement_path announcement, params: { announcement: { title: 'Aviso Editado' } }

      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq 'Você não possui autorização para essa ação'
    end

    it 'must be authenticated as Super Manager or condo associated Manager to edit and announcement' do
      manager = create :manager, email: 'joaquina@email.com', is_super: false
      condo = create :condo
      announcement = create(:announcement, condo:)

      login_as manager, scope: :manager
      patch announcement_path announcement, params: { announcement: { title: 'Aviso Editado' } }

      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq 'Você não possui autorização para essa ação'
    end
  end

  context 'GET /announcements' do
    it 'must be authenticated as Super Manager or condo associated to see announcements list' do
      condo_manager = create :manager, email: 'joaquina@email.com', is_super: false
      condo = create :condo
      create(:announcement, condo:)

      login_as condo_manager, scope: :manager
      get condo_announcements_path condo

      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq 'Você não possui autorização para essa ação'
    end

    it 'must be a resident of the condo to see announcements list' do
      resident = create :resident
      condo = create :condo
      create(:announcement, condo:)

      login_as resident, scope: :resident
      get condo_announcements_path condo

      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq 'Você não possui autorização para essa ação'
    end

    it 'must be authenticated as Super Manager or condo associated to see announcement details' do
      manager = create :manager, email: 'joaquina@email.com', is_super: false
      condo = create :condo
      announcement = create :announcement, condo:, title: 'Reunião de condomínio'

      login_as manager, scope: :manager
      get announcement_path announcement

      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq 'Você não possui autorização para essa ação'
    end

    it 'must be a resident of the condo to see announcement details' do
      resident = create :resident
      condo = create :condo
      announcement = create :announcement, condo:, title: 'Reunião de condomínio'

      login_as resident, scope: :resident
      get announcement_path announcement

      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq 'Você não possui autorização para essa ação'
    end
  end

  context 'DESTROY /announcements' do
    it 'must be authenticated as Super Manager or condo associated to destroy an announcement' do
      condo_manager = create :manager, email: 'joaquina@email.com', is_super: false
      condo = create :condo
      announcement = create :announcement, condo:, title: 'Reunião de condomínio'

      login_as condo_manager, scope: :manager
      delete announcement_path announcement

      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq 'Você não possui autorização para essa ação'
    end
  end
end
