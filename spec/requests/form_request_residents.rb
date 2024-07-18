require 'rails_helper'

describe 'GET /condos/:id/residents' do
  it 'must be authenticated' do
    condo = create :condo

    get residents_condo_path condo

    expect(response).to redirect_to new_manager_session_path
  end

  it 'there are no condos' do
    manager = create :manager

    login_as manager, scope: :manager

    get residents_condo_path(id: 999_999)

    expect(response).to have_http_status :not_found
  end

  it 'its not associated to the condo' do
    manager = create :manager, is_super: false
    condo = create :condo

    login_as manager, scope: :manager

    get residents_condo_path condo

    expect(response).to redirect_to root_path
  end

  it 'must be authenticated as manager' do
    resident = create :resident
    condo = create :condo

    login_as resident, scope: :resident

    get residents_condo_path condo

    expect(response).to redirect_to root_path
  end
end
