require 'rails_helper'

describe 'Manager sees resident details' do
  it 'and user is not a manager' do
    resident = create :resident

    get resident_path resident

    expect(response).to redirect_to(new_manager_session_path)
  end

  it 'and user is a resident' do
    resident = create :resident

    login_as resident, scope: :resident

    get resident_path resident

    expect(response).to redirect_to(root_path)
  end
end
