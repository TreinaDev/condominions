require 'rails_helper'

describe 'Announcements' do
  context 'POST /announcements' do
    it 'must be authenticated to register an announcement' do
      condo = create :condo

      post condo_announcements_path condo, params: { announcement: { title: 'Novo Aviso' } }

      expect(response).to redirect_to root_path
      expect(Announcement.all).to be_empty
      expect(flash[:alert]).to eq 'Você não tem permissão para fazer isso'
    end

    it 'must be authenticated as Super Manager or Condo Manager to create an announcement' do
      manager = create :manager, is_super: false
      condo = create :condo

      login_as manager, scope: :manager
      post condo_announcements_path condo, params: { announcement: { title: 'Novo Aviso' } }

      expect(response).to redirect_to root_path
      expect(Announcement.all).to be_empty
      expect(flash[:alert]).to eq 'Você não tem permissão para fazer isso'
    end

    it 'and a Resident cannot create an announcement' do
      condo = create :condo
      resident = create(:resident, :with_residence, condo:)

      login_as resident, scope: :resident
      post condo_announcements_path condo, params: { announcement: { title: 'Novo Aviso' } }

      expect(response).to redirect_to root_path
      expect(Announcement.all).to be_empty
      expect(flash[:alert]).to eq 'Você não tem permissão para fazer isso'
    end
  end

  context 'PATCH /announcements' do
    it 'must be authenticated to edit an announcement' do
      condo = create :condo
      announcement = create(:announcement, condo:)

      patch announcement_path announcement, params: { announcement: { title: 'Aviso Editado' } }
      announcement.reload

      expect(response).to redirect_to new_manager_session_path
      expect(Announcement.last.title).not_to eq 'Aviso Editado'
      expect(flash[:alert]).to eq 'Para continuar, faça login ou registre-se.'
    end

    it 'must be authenticated as Super Manager or Condo Manager to edit and announcement' do
      manager = create :manager, is_super: false
      condo = create :condo
      announcement = create(:announcement, condo:)

      login_as manager, scope: :manager
      patch announcement_path announcement, params: { announcement: { title: 'Aviso Editado' } }
      announcement.reload

      expect(response).to redirect_to root_path
      expect(Announcement.last.title).not_to eq 'Aviso Editado'
      expect(flash[:alert]).to eq 'Você não tem permissão para fazer isso'
    end

    it 'and a Resident cannot update an announcement' do
      condo = create :condo
      resident = create(:resident, :with_residence, condo:)
      announcement = create(:announcement, condo:)

      login_as resident, scope: :resident
      patch announcement_path announcement, params: { announcement: { title: 'Aviso Editado' } }
      announcement.reload

      expect(response).to redirect_to new_manager_session_path
      expect(Announcement.last.title).not_to eq 'Aviso Editado'
      expect(flash[:alert]).to eq 'Para continuar, faça login ou registre-se.'
    end
  end

  context 'GET /announcements' do
    context 'Manager' do
      it 'must be authenticated as Super Manager or Condo Manager to see announcements list' do
        condo_manager = create :manager, is_super: false
        condo = create :condo
        create(:announcement, condo:)

        login_as condo_manager, scope: :manager
        get condo_announcements_path condo

        expect(response).to redirect_to root_path
        expect(flash[:alert]).to eq 'Você não tem permissão para fazer isso'
      end

      it 'must be authenticated as Super Manager or Condo Manager to see announcement details' do
        manager = create :manager, is_super: false
        condo = create :condo
        announcement = create :announcement, condo:, title: 'Reunião de condomínio'

        login_as manager, scope: :manager
        get announcement_path announcement

        expect(response).to redirect_to root_path
        expect(flash[:alert]).to eq 'Você não tem permissão para fazer isso'
      end
    end

    context 'Resident' do
      it 'must be a Condo Resident to see announcements list' do
        resident = create :resident
        condo = create :condo
        create(:announcement, condo:)

        login_as resident, scope: :resident
        get condo_announcements_path condo

        expect(response).to redirect_to root_path
        expect(flash[:alert]).to eq 'Você não tem permissão para fazer isso'
      end

      it 'must be a Condo Resident to see announcement details' do
        resident = create :resident
        condo = create :condo
        announcement = create :announcement, condo:, title: 'Reunião de condomínio'

        login_as resident, scope: :resident
        get announcement_path announcement

        expect(response).to redirect_to root_path
        expect(flash[:alert]).to eq 'Você não tem permissão para fazer isso'
      end
    end
  end

  context 'DESTROY /announcements' do
    it 'must be authenticated as Super Manager or Condo Manager to destroy an announcement' do
      condo_manager = create :manager, is_super: false
      condo = create :condo
      announcement = create :announcement, condo:, title: 'Reunião de condomínio'

      login_as condo_manager, scope: :manager
      delete announcement_path announcement

      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq 'Você não tem permissão para fazer isso'
    end
  end
end
