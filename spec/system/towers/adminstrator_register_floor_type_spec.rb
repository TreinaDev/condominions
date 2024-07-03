require 'rails_helper'

describe 'Adminstrator edit floor type' do
  it 'from the tower details page' do
    tower = create :tower
    tower.generate_floors

    create :unit_type, description: 'Apartamento de 1 quarto'
    create :unit_type, description: 'Apartamento de 2 quartos'

    visit tower_path tower
    click_on 'Editar Pavimento Tipo'

    expect(current_path).to eq edit_floor_units_condo_tower_path(tower.condo, tower)
  end

  it 'successfully' do
    tower = create :tower
    tower.generate_floors

    create :unit_type, description: 'Apartamento de 1 quarto'
    create :unit_type, description: 'Apartamento de 2 quartos'

    visit edit_floor_units_condo_tower_path(tower.condo, tower)

    within '#unit-1' do
      select 'Apartamento de 2 quartos', from: 'Tipo de Unidade'
    end

    within '#unit-2' do
      select 'Apartamento de 1 quarto', from: 'Tipo de Unidade'
    end

    within '#unit-3' do
      select 'Apartamento de 2 quartos', from: 'Tipo de Unidade'
    end

    within '#unit-4' do
      select 'Apartamento de 1 quarto', from: 'Tipo de Unidade'
    end

    click_on 'Atualizar Pavimento Tipo'

    expect(current_path).to eq tower_path tower
    expect(page).to have_content 'Pavimento Tipo atualizado com sucesso'
    expect(page).to have_content 'Torre A'
    expect(tower.floors.first.units.first.unit_type.description).to eq 'Apartamento de 2 quartos'
    expect(tower.floors.first.units.last.unit_type.description).to eq 'Apartamento de 1 quarto'
  end

  it 'and fails if there is unselected unit types' do
    tower = create :tower
    tower.generate_floors

    create :unit_type, description: 'Apartamento de 1 quarto'
    create :unit_type, description: 'Apartamento de 2 quartos'

    visit edit_floor_units_condo_tower_path(tower.condo, tower)

    within '#unit-1' do
      select 'Selecione o tipo de unidade', from: 'Tipo de Unidade'
    end

    within '#unit-2' do
      select 'Selecione o tipo de unidade', from: 'Tipo de Unidade'
    end

    within '#unit-3' do
      select 'Selecione o tipo de unidade', from: 'Tipo de Unidade'
    end

    click_on 'Atualizar Pavimento Tipo'

    expect(page).to have_content 'Defina o tipo de unidade para todas as unidades'
  end
end
