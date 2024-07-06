require 'rails_helper'

describe 'Administrator view list of towers' do
  it 'and must be authenticated' do
    condo = create(:condo)

    visit condo_towers_path(condo)

    expect(current_path).to eq new_manager_session_path
  end

  it 'and see a list of condo´s towers from condo show' do
    condo = create(:condo)
    user = create :manager
    tower_a = build :tower, name: 'Torre A', condo_id: condo.id
    tower_a.generate_floors
    tower_b = build :tower, name: 'Torre B', condo_id: condo.id
    tower_b.generate_floors
    tower_c = build :tower, name: 'Torre C', condo_id: condo.id
    tower_c.generate_floors

    login_as user, scope: :manager
    visit condo_path(condo)
    click_on 'Listar Torres'

    expect(current_path).to eq condo_towers_path(condo)
    within '.list' do
      expect(page).to have_link 'Torre A'
      expect(page).to have_link 'Torre B'
      expect(page).to have_link 'Torre C'
    end
  end

  it 'and see a tower details when click on tower´s name' do
    condo = create(:condo)
    user = create :manager
    tower_a = build :tower, name: 'Torre A', condo_id: condo.id
    tower_a.generate_floors

    login_as user, scope: :manager
    visit condo_path(condo)
    click_on 'Listar Torres'
    click_on 'Torre A'

    expect(current_path).to eq tower_path(tower_a)
  end

  it 'and don´t see other condo´s towers' do
    condo_a = create(:condo)
    condo_b = create(:condo)
    user = create :manager
    tower_a = build :tower, name: 'Torre A', condo_id: condo_a.id
    tower_a.generate_floors
    tower_b = build :tower, name: 'Torre B', condo_id: condo_b.id
    tower_b.generate_floors

    login_as user, scope: :manager
    visit condo_path(condo_a)
    click_on 'Listar Torres'

    expect(current_path).to eq condo_towers_path(condo_a)
    within '.list' do
      expect(page).to have_link 'Torre A'
      expect(page).not_to have_link 'Torre B'
    end
  end

  it 'resident can´t see link to list of towers' do
    condo = create(:condo)
    resident = create :resident

    login_as resident, scope: :resident
    visit condo_path(condo)

    expect(current_path).to eq condo_path(condo)
    expect(page).not_to have_link 'Listar Torres'
  end

  it 'resident can´t access the list of condo´s tower' do
    condo = create(:condo)
    resident = create :resident

    login_as resident, scope: :resident
    visit condo_towers_path(condo)

    expect(current_path).to eq root_path
  end
end
