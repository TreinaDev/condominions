require 'rails_helper'

describe 'managers access page to set a resident as owner' do
  it 'and is not authenticated' do
    resident = create :resident

    visit new_resident_tenant_path resident

    expect(current_path).to eq new_manager_session_path
  end

  it 'and choose an existent unit from the flash message(success)' do
    manager = create :manager
    create :condo, name: 'Condominio Errado'
    condo = create :condo, name: 'Condominio Certo'
    create :tower, 'condo' => condo, name: 'Torre errada'
    create :tower, 'condo' => condo, name: 'Torre correta', floor_quantity: 2, units_per_floor: 2
    resident = create :resident, :not_owner, full_name: 'Adroaldo Silva'

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
    expect(resident.units.last.short_identifier).to eq '12'
  end

  it 'and choose an existent unit (success)' do
    manager = create :manager
    resident = create(:resident, :not_owner, full_name: 'Adroaldo Silva')

    login_as manager, scope: :manager

    visit root_path
    click_on 'Cadastro de Adroaldo Silva incompleto, por favor, ' \
             'adicione unidades possuídas, caso haja, ou finalize o cadastro.'

    click_on 'Finalizar Cadastro'

    expect(current_path).to eq new_resident_tenant_path resident
    expect(page).to have_content 'Propriedades cadastradas com sucesso!'
    resident.reload
    expect(resident.not_tenant?).to eq true
  end

  it 'and choose an existent unit (success)' do
    manager = create :manager
    create :condo, name: 'Condominio Errado'
    condo = create :condo, name: 'Condominio Certo'
    create :tower, 'condo' => condo, name: 'Torre errada'
    tower = create :tower, 'condo' => condo, name: 'Torre correta', floor_quantity: 2, units_per_floor: 2
    resident = create :resident, :not_owner, full_name: 'Adroaldo Silva'

    resident.units << tower.floors.first.units.first
    resident.units << tower.floors.last.units.last

    login_as manager, scope: :manager

    visit root_path
    click_on 'Cadastro de Adroaldo Silva incompleto, por favor, ' \
             'adicione unidades possuídas, caso haja, ou finalize o cadastro.'

    within(:css, '.units-array .unit:nth-of-type(1)') do
      click_on 'Remover Propriedade'
    end

    expect(page).to have_content 'Unidade: 22'
    expect(page).not_to have_content 'Unidade: 11'
  end

  it 'and try to inform with blank fields' do
    manager = create :manager
    resident = create :resident, :not_owner, full_name: 'Adroaldo Silva'
    login_as manager, scope: :manager

    visit root_path
    click_on 'Cadastro de Adroaldo Silva incompleto, por favor, ' \
             'adicione unidades possuídas, caso haja, ou finalize o cadastro.'

    click_on 'Adicionar Propriedade'

    expect(current_path).to eq new_resident_owner_path(resident)
    expect(page).to have_content 'Unidade não pode ficar em branco'
  end

  it 'and try to inform the same unit again for an owner' do
    manager = create :manager
    condo = create :condo, name: 'Condominio Certo'
    create :tower, 'condo' => condo, name: 'Torre correta', floor_quantity: 2, units_per_floor: 2
    resident = create :resident, :not_owner, full_name: 'Adroaldo Silva'

    login_as manager, scope: :manager

    visit root_path
    click_on 'Cadastro de Adroaldo Silva incompleto, por favor, ' \
             'adicione unidades possuídas, caso haja, ou finalize o cadastro.'

    select 'Condominio Certo', from: 'Condomínio'
    select 'Torre correta', from: 'Torre'
    select '1', from: 'Andar'
    select '2', from: 'Unidade'
    click_on 'Adicionar Propriedade'

    select 'Condominio Certo', from: 'Condomínio'
    select 'Torre correta', from: 'Torre'
    select '1', from: 'Andar'
    select '2', from: 'Unidade'
    click_on 'Adicionar Propriedade'

    expect(current_path).to eq new_resident_owner_path resident
    expect(page).to have_content 'Unidade já cadastrada para esse proprietário'
    expect(page).to have_content 'Condomínio: Condominio Certo'
    expect(page).to have_content 'Torre: Torre correta'
    expect(page).to have_content 'Unidade: 12'
    resident.reload
    expect(resident.units.last.short_identifier).to eq '12'
  end
end
