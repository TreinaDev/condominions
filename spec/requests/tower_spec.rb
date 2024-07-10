require 'rails_helper'

describe 'POST /towers' do
  it 'must be authenticated to register a tower' do
    condo = create :condo

    post condo_towers_path(condo),
         params: { tower:
                         { name: 'Torre do Rubinhos',
                           floor_quantity: 3,
                           units_per_floor: 4 } }

    expect(response).to redirect_to new_manager_session_path
    expect(flash[:alert]).to eq 'Para continuar, faça login ou registre-se.'
  end
end

describe 'PATCH /towers' do
  it 'must be authenticated to register a tower' do
    condo = create :condo
    tower = create(:tower, floor_quantity: 3, units_per_floor: 2, condo:)

    patch update_floor_units_condo_tower_path(condo, tower)

    expect(response).to redirect_to new_manager_session_path
    expect(flash[:alert]).to eq 'Para continuar, faça login ou registre-se.'
  end
end
