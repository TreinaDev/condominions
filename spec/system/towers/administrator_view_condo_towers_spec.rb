require 'rails_helper'

describe 'Administrator view list of towers' do
  it 'and only sees the list of towers that belong to the condo' do
    condo = create :condo, name: 'Residencial on Rails'
    condo2 = create :condo
    user = create :manager
    create :tower, name: 'Torre A', condo_id: condo.id
    create :tower, name: 'Torre B', condo_id: condo.id
    create :tower, name: 'Torre C', condo_id: condo.id
    create :tower, name: 'Torre Z', condo_id: condo2.id

    login_as user, scope: :manager
    visit root_path
    within('#condos-list') { click_on 'Residencial on Rails' }

    within '#towers' do
      expect(page).to have_content 'Torre A'
      expect(page).to have_content 'Torre B'
      expect(page).to have_content 'Torre C'
      expect(page).not_to have_content 'Torre Z'
    end
  end

  it 'and see a tower details when click on tower´s name' do
    condo = create :condo
    user = create :manager
    tower_a = create :tower, name: 'Torre A', condo_id: condo.id

    login_as user, scope: :manager
    visit condo_path condo
    find('#tower-1').click

    expect(current_path).to eq tower_path tower_a
  end

  it 'and resident can´t see list of towers' do
    condo = create :condo
    create :tower, condo:, name: 'Torre A'
    resident = create :resident

    login_as resident, scope: :resident
    visit condo_path condo

    expect(page).not_to have_content 'Listar Torres'
    expect(page).not_to have_content 'Torre A'
  end
end
