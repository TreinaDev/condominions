require 'rails_helper'

describe 'Manager sees resident details' do
  it 'from the list of residents' do
    manager = create :manager
    condo = create :condo, name: 'Condominio A'
    tower = create :tower, 'condo' => condo, name: 'Torre A', floor_quantity: 2, units_per_floor: 2
    unit11 = tower.floors[0].units[0]
    unit12 = tower.floors[0].units[1]
    unit22 = tower.floors[1].units[1]

    resident = create :resident, :mail_confirmed, full_name: 'Adroaldo Silva', properties: [unit11, unit12],
                                                  residence: unit11, email: 'adroaldo@email.com',
                                                  registration_number: '678.490.811-29'

    create :resident, :mail_confirmed, full_name: 'Maria Carla', properties: [unit22], residence: unit22,
                                       email: 'maria@email.com', registration_number: '334.133.716-49'

    resident.user_image.attach(io: Rails.root.join('spec/support/images/resident_photo.jpg').open,
                               filename: 'resident_photo.jpg')

    login_as manager, scope: :manager
    visit condo_path(condo)
    click_on 'Lista de Moradores'
    find('#resident-1').click

    expect(page).to have_current_path resident_path(resident), wait: 3
    within '#personal_data' do
      expect(page).to have_content 'Adroaldo Silva'
      expect(page).to have_content 'adroaldo@email.com'
      expect(page).to have_content '678.490.811-29'
      expect(page).to have_css 'img[src*="resident_photo.jpg"]'
      expect(page).not_to have_content '334.133.716-49'
    end
    within '.residence' do
      expect(page).to have_content 'Dados da Moradia'
      expect(page).to have_content 'Condominio A'
      expect(page).to have_content 'Torre A'
      expect(page).to have_content 'Unidade: 11'
      expect(page).not_to have_content 'Unidade: 22'
    end
    within '.properties' do
      expect(page).to have_content 'Unidades Possuídas'
      expect(page).to have_content 'Condominio A'
      expect(page).to have_content 'Torre A'
      expect(page).to have_content 'Unidade: 11'
      expect(page).to have_content 'Unidade: 12'
      expect(page).not_to have_content 'Unidade: 22'
    end
    expect(page).to have_button 'Editar Propriedades/Residência'
  end

  it 'and resident has no residence' do
    manager = create :manager
    condo = create :condo, name: 'Condominio A'
    tower = create :tower, 'condo' => condo, name: 'Torre A', floor_quantity: 2, units_per_floor: 2
    unit11 = tower.floors[0].units[0]

    resident = create :resident, :mail_confirmed, full_name: 'Adroaldo Silva', properties: [unit11],
                                                  email: 'adroaldo@email.com', registration_number: '678.490.811-29'

    login_as manager, scope: :manager
    visit condo_path(condo)
    click_on 'Lista de Moradores'
    find('#resident-1').click

    expect(current_path).to eq resident_path resident
    within '.residence' do
      expect(page).to have_content 'Dados da Moradia'
      expect(page).to have_content 'Não reside em um condomínio cadastrado'
    end
  end

  it 'and resident has no property' do
    manager = create :manager
    condo = create :condo, name: 'Condominio A'
    tower = create :tower, 'condo' => condo, name: 'Torre A', floor_quantity: 2, units_per_floor: 2
    unit11 = tower.floors[0].units[0]

    resident = create :resident, :mail_confirmed, full_name: 'Adroaldo Silva', residence: unit11,
                                                  email: 'adroaldo@email.com', registration_number: '678.490.811-29'

    create :resident, :mail_confirmed, full_name: 'Maria Carla', properties: [unit11],
                                       email: 'maria@email.com', registration_number: '334.133.716-49'

    login_as manager, scope: :manager
    visit condo_path(condo)
    click_on 'Lista de Moradores'
    find('#resident-1').click

    expect(current_path).to eq resident_path resident
    within '.properties' do
      expect(page).to have_content 'Morador não possui propriedades cadastradas no condomínio'
    end
  end
end
