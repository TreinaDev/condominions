require 'rails_helper'

describe 'Adminstrator register floor composition' do
  it 'sucessfuly' do
    tower = create(:tower)

    tower.floor_quantity.times do
      create(:floor, tower:)
    end

    visit edit_floor_units_condo_tower_path(tower)

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

    expect(current_path).to eq tower_path(tower)
    expect(page).to have_content 'Pavimento Tipo cadastrado com sucesso!'
    expect(page).to have_content 'Torre A'
    expect(tower.floors.first.units.first.unit_type.description).to eq 'Apartamento de 2 quartos'
    expect(tower.floors.first.units.last.unit_type.description).to eq 'Apartamento de 1 quarto'
  end
end
