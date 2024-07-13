require 'rails_helper'

describe "Administrator view condo tower's list" do
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
    click_on 'Lista de Torres'

    within '#towers' do
      expect(page).to have_content 'Torre A'
      expect(page).to have_content 'Torre B'
      expect(page).to have_content 'Torre C'
      expect(page).not_to have_content 'Torre Z'
    end
  end

  it 'and resident can´t see list of towers' do
    condo = create :condo
    create :tower, condo:, name: 'Torre A'
    resident = create :resident

    login_as resident, scope: :resident
    visit condo_path condo

    expect(page).not_to have_content 'Lista de Torres'
    expect(page).not_to have_content 'Torre A'
  end

  it 'and sees a message if there are no towers on condo' do
    manager = create :manager
    condo = create :condo

    login_as manager, scope: :manager
    visit condo_path condo
    click_on 'Lista de Torres'

    expect(page).to have_content 'Não existem torres para esse condomínio'
  end
end
