require 'rails_helper'

describe 'Manager sets owner in register' do 

  it 'POST /residents/:resident_id/owners' do 
    resident = create(:resident, full_name: 'Adroaldo Silva')
    post resident_owners_path(resident), params: { floor_id: '15' }

    expect(response).to redirect_to new_manager_session_path
    expect(flash[:alert]).to eq 'Para continuar, faça login ou registre-se.'
  end

  it 'DELETE /residents/:resident_id/owner' do 
    resident = create(:resident, full_name: 'Adroaldo Silva')
    unit = create(:unit)

    resident.units << unit

    delete resident_owner_path(resident, unit), params: { floor_id: '15' }

    expect(response).to redirect_to new_manager_session_path
    expect(flash[:alert]).to eq 'Para continuar, faça login ou registre-se.'
  end

end