require 'rails_helper'

describe 'GET /residents/find_towers' do
  it 'there are no condos' do
    manager = create :manager

    login_as manager, scope: :manager

    get find_towers_residents_path

    expect(response).to have_http_status :not_found
  end

  it 'there are no towers' do
    manager = create :manager
    condo = create :condo

    login_as manager, scope: :manager

    get find_towers_residents_path 'condo' => condo
    expect(response).to have_http_status :not_found
  end

  it 'must be authenticated' do
    condo = create :condo

    get find_towers_residents_path 'condo' => condo

    expect(response).to redirect_to root_path
  end

  it 'must be authenticated as manager' do
    resident = create :resident
    condo = create :condo

    login_as resident, scope: :resident

    get find_towers_residents_path 'condo' => condo

    expect(response).to redirect_to root_path
  end
end
