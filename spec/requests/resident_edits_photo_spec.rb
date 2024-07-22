require 'rails_helper'

describe 'Resident edits photo' do
  context 'GET /residents/:id/edit_photo' do
    it 'must be authenticated to access edit_photo' do
      resident = create :resident

      get edit_photo_resident_path resident

      expect(response).to redirect_to new_resident_session_path
    end

    it 'must be authenticated as resident to edit photo' do
      manager = create :manager
      resident = create :resident

      login_as manager, scope: :manager
      get edit_photo_resident_path resident

      expect(response).to redirect_to root_path
    end

    it 'and cannot edit another resident photo' do
      resident = create :resident
      other_resident = create :resident

      login_as other_resident, scope: :resident
      get edit_photo_resident_path resident

      expect(response).to redirect_to root_path
    end
  end

  context 'PATCH /residents/:id/edit_photo' do
    it 'must be authenticated to edit photo' do
      resident = create :resident

      patch update_photo_resident_path resident

      expect(response).to redirect_to new_resident_session_path
    end

    it 'must be authenticated as resident to edit photo' do
      manager = create :manager
      resident = create :resident

      login_as manager, scope: :manager
      patch update_photo_resident_path resident

      expect(response).to redirect_to root_path
    end

    it 'and cannot edit another resident photo' do
      resident = create :resident
      other_resident = create :resident

      login_as other_resident, scope: :resident
      patch update_photo_resident_path resident

      expect(response).to redirect_to root_path
    end
  end
end
