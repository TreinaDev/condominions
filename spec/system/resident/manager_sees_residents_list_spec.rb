require 'rails_helper'

describe 'Manager sees residents list' do
  it 'from condo details page' do
    manager = create :manager
    condo = create :condo, name: 'Condominio Certo'
    tower = create :tower, 'condo' => condo, name: 'Torre correta', floor_quantity: 2, units_per_floor: 2
    unit11 = tower.floors[0].units[0]
    create :resident, :mail_confirmed, full_name: 'Adroaldo Silva', properties: [unit11], email: 'Adroaldo@email.com'
    create :resident, :not_owner, full_name: 'Sandra Soares', residence: unit11, email: 'sandra@email'
    create :resident, :not_owner, full_name: 'João Soares', email: 'joao@email'

    login_as manager, scope: :manager
    visit condo_path(condo)
    click_on 'Lista de Moradores'

    within '#residents' do
      expect(page).to have_content 'Adroaldo Silva'
      expect(page).to have_content 'Sandra Soares'
      expect(page).to have_link 'Visualizar'
      expect(page).not_to have_content 'João Soares'
    end
  end

  it 'and theres no residents' do
    manager = create :manager
    condo = create :condo, name: 'Condominio Certo'
    create :tower, 'condo' => condo, name: 'Torre correta', floor_quantity: 2, units_per_floor: 2

    login_as manager, scope: :manager
    visit condo_path(condo)
    click_on 'Lista de Moradores'

    within '#residents' do
      expect(page).to have_content 'Não existem moradores Cadastrados.'
    end
  end

  it 'and search for a resident' do
    manager = create :manager
    condo = create :condo
    tower = create(:tower, condo:)
    unit11 = tower.floors[0].units[0]
    unit12 = tower.floors[0].units[1]
    create :resident, full_name: 'Adroaldo Silva', properties: [unit11], email: 'Adroaldo@email.com'
    create :resident, full_name: 'Sandra Silva', residence: unit11, email: 'sandra@email'
    create :resident, full_name: 'João Soares', properties: [unit12], email: 'joao@email'

    login_as manager, scope: :manager
    visit condo_path(condo)
    click_on 'Lista de Moradores'
    within '#residents' do
      fill_in 'search', with: 'Silva'
    end

    within '#residentsResult' do
      expect(page).to have_content 'Adroaldo Silva'
      expect(page).to have_content 'Sandra Silva'
      expect(page).not_to have_content 'João Soares'
    end
  end

  it 'and dont find the resident that is searching for' do
    manager = create :manager
    condo = create :condo
    tower = create(:tower, condo:)
    unit11 = tower.floors[0].units[0]
    create :resident, full_name: 'Adroaldo Silva', properties: [unit11], email: 'Adroaldo@email.com'

    login_as manager, scope: :manager
    visit condo_path(condo)
    click_on 'Lista de Moradores'
    within '#residents' do
      fill_in 'search', with: 'Renan'
    end

    within '#residentsResult' do
      expect(page).not_to have_content 'Adroaldo Silva'
      expect(page).to have_content 'Morador não encontrado'
    end
  end

  it 'and is not authenticated as a resident' do
    condo = create :condo
    tower = create(:tower, condo:)
    unit11 = tower.floors[0].units[0]
    resident = create :resident, full_name: 'Adroaldo Silva', properties: [unit11], email: 'Adroaldo@email.com'

    login_as resident, scope: :resident
    visit condo_path(condo)

    expect(page).not_to have_button 'Lista de Moradores'
  end
end
