require 'rails_helper'

describe 'managers access page to set a resident as owner' do
  it 'and is not authenticated' do
    resident = create :resident

    visit new_resident_tenant_path resident

    expect(current_path).to eq new_manager_session_path
  end

  it 'and choose an existent unit from the flash message (success)' do
    manager = create :manager
    create :condo, name: 'Condominio Errado'
    condo = create :condo, name: 'Condominio Certo'
    tower = create :tower, 'condo' => condo, name: 'Torre errada'
    create :tower, 'condo' => condo, name: 'Torre correta', floor_quantity: 2, units_per_floor: 2
    resident = create :resident, :property_registration_pending, full_name: 'Adroaldo Silva',
                                                                 properties: [tower.floors[0].units[1]]

    login_as manager, scope: :manager
    visit root_path
    click_on 'Cadastro de Adroaldo Silva incompleto, por favor, ' \
             'adicione unidades possuídas, caso haja, ou finalize o cadastro.'

    select 'Condominio Certo', from: 'Condomínio'
    select 'Torre correta', from: 'Torre'
    select '1', from: 'Andar'
    select '2', from: 'Unidade'
    click_on 'Adicionar Propriedade'

    expect(current_path).to eq new_resident_owner_path resident
    expect(page).to have_content 'Propriedade cadastrada com sucesso!'
    expect(page).to have_content 'Condomínio: Condominio Certo'
    expect(page).to have_content 'Torre: Torre correta'
    expect(page).to have_content 'Unidade: 12'
    resident.reload
    expect(resident.properties.last.short_identifier).to eq '12'
  end

  it 'and the resident do not have properties on condo' do
    manager = create :manager
    resident = create(:resident, :property_registration_pending, full_name: 'Adroaldo Silva')

    login_as manager, scope: :manager

    visit new_resident_owner_path resident

    click_on 'Finalizar Cadastro'

    expect(current_path).to eq new_resident_tenant_path resident
    expect(page).to have_content 'Propriedades cadastradas com sucesso!'
    resident.reload
    expect(resident.residence_registration_pending?).to eq true
  end

  it 'and can remove an unit from resident' do
    manager = create :manager
    create :condo, name: 'Condominio Errado'
    condo = create :condo, name: 'Condominio Certo'
    create :tower, 'condo' => condo, name: 'Torre errada'
    tower = create :tower, 'condo' => condo, name: 'Torre correta', floor_quantity: 2, units_per_floor: 2
    resident = create :resident, :property_registration_pending, full_name: 'Adroaldo Silva'

    resident.properties << tower.floors.first.units.first
    resident.properties << tower.floors.last.units.last

    login_as manager, scope: :manager

    visit root_path
    click_on 'Cadastro de Adroaldo Silva incompleto, por favor, ' \
             'adicione unidades possuídas, caso haja, ou finalize o cadastro.'

    within(:css, '.units-array .unit:nth-of-type(1)') do
      click_on 'Remover'
    end

    expect(page).to have_content 'Unidade: 22'
    expect(page).not_to have_content 'Unidade: 11'
  end

  it 'and try to inform with blank fields' do
    manager = create :manager
    resident = create :resident, :property_registration_pending, full_name: 'Adroaldo Silva'
    login_as manager, scope: :manager

    visit new_resident_owner_path resident
    click_on 'Adicionar Propriedade'

    expect(current_path).to eq new_resident_owner_path(resident)
    expect(page).to have_content 'Unidade não pode ficar em branco'
  end

  it 'and try to inform the same unit again for an owner' do
    manager = create :manager
    condo = create :condo, name: 'Condominio Certo'
    create :tower, 'condo' => condo, name: 'Torre correta', floor_quantity: 2, units_per_floor: 2
    resident = create :resident, :property_registration_pending, full_name: 'Adroaldo Silva'

    login_as manager, scope: :manager

    visit new_resident_owner_path resident

    select 'Condominio Certo', from: 'Condomínio'
    sleep 1
    select 'Torre correta', from: 'Torre'
    select '1', from: 'Andar'
    select '2', from: 'Unidade'
    click_on 'Adicionar Propriedade'

    select 'Condominio Certo', from: 'Condomínio'
    sleep 1
    select 'Torre correta', from: 'Torre'
    select '1', from: 'Andar'
    select '2', from: 'Unidade'
    click_on 'Adicionar Propriedade'

    expect(current_path).to eq new_resident_owner_path resident
    expect(page).to have_content 'Unidade já possui proprietário'
    expect(page).to have_content 'Condomínio: Condominio Certo'
    expect(page).to have_content 'Torre: Torre correta'
    expect(page).to have_content 'Unidade: 12'
    resident.reload
    expect(resident.properties.last.short_identifier).to eq '12'
  end

  it 'and cannot set as owner for an unit that already has an owner' do
    manager = create :manager
    condo = create :condo, name: 'Condominio Certo'
    tower = create :tower, 'condo' => condo, name: 'Torre correta', floor_quantity: 2, units_per_floor: 2
    unit11 = tower.floors[0].units[0]
    create :resident, :mail_confirmed, full_name: 'Adroaldo Silva', properties: [unit11], email: 'Adroaldo@email.com'
    resident = create :resident, :property_registration_pending, full_name: 'Sandra Soares'

    login_as manager, scope: :manager
    visit new_resident_owner_path resident
    select 'Condominio Certo', from: 'Condomínio'
    sleep 1
    select 'Torre correta', from: 'Torre'
    select '1', from: 'Andar'
    select '1', from: 'Unidade'
    click_on 'Adicionar Propriedade'

    expect(current_path).to eq new_resident_owner_path resident
    expect(page).to have_content 'Unidade já possui proprietário'
  end

  it 'and can not remove a owner from a condo that its not associated' do
    manager = create :manager, is_super: false
    condo = create :condo, name: 'Condominio Errado'
    tower = create :tower, 'condo' => condo, name: 'Torre correta', floor_quantity: 2, units_per_floor: 2
    unit11 = tower.floors[0].units[0]
    second_condo = create :condo, name: 'Condominio Certo'
    second_tower = create :tower, 'condo' => second_condo, name: 'Torre Secundaria', floor_quantity: 2,
                                  units_per_floor: 2
    second_unit22 = second_tower.floors[0].units[0]
    resident = create :resident, :mail_confirmed, full_name: 'Adroaldo Silva', properties: [unit11, second_unit22]
    second_condo.managers << manager

    login_as manager, scope: :manager
    visit new_resident_owner_path resident

    within '.units-array .unit:nth-of-type(1)' do
      expect(page).not_to have_button 'Remover'
    end
    within '.units-array .unit:nth-of-type(2)' do
      expect(page).to have_button 'Remover'
    end
  end
end
