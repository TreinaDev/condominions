require 'rails_helper'

describe 'Unit' do
  context 'GET find_units?id=[tower_id]' do
    it 'successfully' do
      manager = create :manager
      tower = create :tower, :with_four_units, condo: create(:condo), unit_types: [create(:unit_type)]

      login_as manager, scope: :manager
      get "/units/find_units?id=#{tower.id}"

      expect(response).to have_http_status :ok
      expect(response.body).to include tower.units.last.id.to_s
    end

    it 'only if authenticated' do
      tower = create :tower, :with_four_units, condo: create(:condo), unit_types: [create(:unit_type)]

      get "/units/find_units?id=#{tower.id}"

      expect(response).to redirect_to new_manager_session_path
      expect(response.body).not_to include tower.units.last.id.to_s
    end
  end
end
