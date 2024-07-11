require 'rails_helper'

describe 'Manager sets tenants in register' do 

  it 'POST /residents/:resident_id/tenants' do 
    resident = create(:resident, full_name: 'Adroaldo Silva')
    post resident_tenants_path(resident), params: { floor_id: '15' }

    expect(response).to redirect_to new_manager_session_path
    expect(flash[:alert]).to eq 'Para continuar, faça login ou registre-se.'
  end

end