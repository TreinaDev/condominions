require 'rails_helper'

describe 'GET /residents/find_towers' do 
  it 'there are no condos' do 
    manager = create(:manager)

    login_as(manager, scope: :manager)
    get find_towers_residents_path

    expect(response.status).to eq 404
  end

  it 'there are no towers' do
    manager = create(:manager)
    condo = create(:condo)

    login_as(manager, scope: :manager)
    get find_towers_residents_path('condo' => condo)

    expect(response.status).to eq 404
  end
end