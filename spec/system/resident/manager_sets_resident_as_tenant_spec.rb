require 'rails_helper'

describe 'managers access page to set a resident as tenant' do
  it 'and choose an existent unit (success)' do
    manager = create :manager
    create :condo, name: 'Condominio Errado'
    condo = create :condo, name: 'Condominio Certo'
    create :tower, 'condo' => condo, name: 'Torre errada'
    tower = create :tower, 'condo' => condo, name: 'Torre correta', floor_quantity: 2, units_per_floor: 2
    tower.generate_floors
    resident = create(:resident)

    login_as manager, scope: :manager

    visit new_resident_tenant_path resident

    select 'Condominio Certo', from: 'Condomínio'
    select 'Torre correta', from: 'Torre'
    select '1', from: 'Andar'
    select '2', from: 'Unidade'
    click_on 'Atualizar Morador'

    expect(current_path).to eq new_resident_owner_path resident
    expect(page).to have_content 'Residência cadastrada com sucesso!'
    resident.reload
    expect(resident.residence).not_to eq nil
  end

  it 'and resident does not live in condo' do
    manager = create :manager
    create :condo, name: 'Condominio Errado'
    condo = create :condo, name: 'Condominio Certo'
    create :tower, 'condo' => condo, name: 'Torre errada'
    tower = create :tower, 'condo' => condo, name: 'Torre correta', floor_quantity: 2, units_per_floor: 2
    tower.generate_floors
    resident = create(:resident)

    login_as manager, scope: :manager

    visit new_resident_tenant_path resident

    click_on 'Não residente neste condomínio'

    expect(current_path).to eq new_resident_owner_path resident
    expect(page).to have_content 'Residência cadastrada com sucesso!'
    resident.reload
    expect(resident.residence).to eq nil
  end

  it "and there's on unit selected (fail)" do
    manager = create :manager
    create :condo, name: 'Condominio Errado'

    resident = create(:resident)

    login_as manager, scope: :manager

    visit new_resident_tenant_path resident

    click_on 'Atualizar Morador'

    expect(current_path).to eq new_resident_tenant_path resident
    expect(page).to have_content 'Unidade não pode ficar em branco'
    resident.reload
    expect(resident.residence).to eq nil
  end
end
