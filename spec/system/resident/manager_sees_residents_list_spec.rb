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
end
