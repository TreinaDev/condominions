require 'rails_helper'

describe 'Towers' do
  context 'GET /towers' do
    it 'must be authenticated as Super Manager or condo associated' do
      manager = create :manager, is_super: false
      condo = create :condo
      tower = create(:tower, condo:)

      login_as manager, scope: :manager
      get tower_path tower

      expect(response).to redirect_to root_path
    end
  end

  context 'POST /towers' do
    it 'must be authenticated to register a tower' do
      condo = create :condo

      post condo_towers_path(condo),
           params: { tower: { name: 'Torre do Rubinhos',
                              floor_quantity: 3,
                              units_per_floor: 4 } }

      expect(response).to redirect_to new_manager_session_path
      expect(flash[:alert]).to eq 'Para continuar, faça login ou registre-se.'
    end

    it 'and can only be authenticated as a manager to register a tower' do
      resident = create :resident
      condo = create :condo
      create :tower, name: 'Torre Existente'

      login_as resident, scope: :resident
      post condo_towers_path(condo),
           params: { tower: { name: 'Torre do Rubinhos',
                              floor_quantity: 3,
                              units_per_floor: 4 } }

      expect(response).to redirect_to root_path
      expect(Tower.last.name).not_to eq 'Torre do Rubinhos'
    end

    it 'and he is not associated or is not a super' do
      manager = create :manager, is_super: false
      condo = create :condo

      login_as manager, scope: :manager
      post condo_towers_path condo,
                             params: { tower: { name: 'Torre do Rubinhos',
                                                floor_quantity: 3,
                                                units_per_floor: 4 } }

      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq 'Você não tem permissão para fazer isso'
    end
  end

  context 'PATCH /update_floor_units' do
    it 'must be authenticated to update floor units from a tower' do
      condo = create :condo
      tower = create(:tower, floor_quantity: 3, units_per_floor: 2, condo:)

      patch update_floor_units_condo_tower_path(condo, tower)

      expect(response).to redirect_to new_manager_session_path
      expect(flash[:alert]).to eq 'Para continuar, faça login ou registre-se.'
    end

    it 'and can only be authenticated as a manager to update floor units from a tower' do
      condo = create :condo
      tower = create(:tower, floor_quantity: 3, units_per_floor: 2, condo:)
      resident = create :resident

      login_as resident, scope: :resident
      patch update_floor_units_condo_tower_path(condo, tower)

      expect(response).to redirect_to root_path
    end

    it 'and updates all unit type fractions within the condo' do
      manager = create :manager
      condo = create :condo
      first_unit_type = create(:unit_type, condo:, metreage: 50)
      second_unit_type = create(:unit_type, condo:, metreage: 100)
      create :tower, :with_four_units, floor_quantity: 3, condo:, unit_types: [first_unit_type, second_unit_type]

      tower = create(:tower, floor_quantity: 3, units_per_floor: 2, condo:)
      unit_types = { '0' => first_unit_type.id, '1' => second_unit_type.id }

      login_as manager, scope: :manager
      patch update_floor_units_condo_tower_path(condo, tower), params: { unit_types: }
      tower.reload

      expect(first_unit_type.reload.fraction).to eq 3.7037
      expect(second_unit_type.reload.fraction).to eq 7.40741
    end

    it 'and he is not associated or is not a super' do
      manager = create :manager, is_super: false
      condo = create :condo
      first_unit_type = create(:unit_type, condo:, metreage: 50)
      second_unit_type = create(:unit_type, condo:, metreage: 100)
      create :tower, :with_four_units, floor_quantity: 3, condo:, unit_types: [first_unit_type, second_unit_type]

      tower = create(:tower, floor_quantity: 3, units_per_floor: 2, condo:)
      unit_types = { '0' => first_unit_type.id, '1' => second_unit_type.id }

      login_as manager, scope: :manager
      patch update_floor_units_condo_tower_path(condo, tower), params: { unit_types: }
      tower.reload

      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq 'Você não tem permissão para fazer isso'
    end
  end
end
