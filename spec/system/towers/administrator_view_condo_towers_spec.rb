require 'rails_helper'

describe 'Administrator view list of tower' do
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

  it 'morador nao fe link de torres' do

  end

  it 'morador nao acessa página de listagem de torres' do
    
  end
end
