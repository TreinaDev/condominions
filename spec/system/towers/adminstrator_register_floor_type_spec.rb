require 'rails_helper'

describe 'Administrator edit floor type' do
  it 'only if authenticated' do
    tower = create :tower
    tower.generate_floors
    create :unit_type, description: 'Apartamento de 1 quarto'
    create :unit_type, description: 'Apartamento de 2 quartos'

    visit edit_floor_units_condo_tower_path(tower.condo, tower)

    expect(current_path).to eq new_manager_session_path
  end

  it 'from the tower details page' do
    user = create :manager
    tower = create :tower
    tower.generate_floors

    create :unit_type, description: 'Apartamento de 1 quarto'
    create :unit_type, description: 'Apartamento de 2 quartos'

    login_as user, scope: :manager
    visit tower_path tower
    click_on 'Editar Pavimento Tipo'

    expect(current_path).to eq edit_floor_units_condo_tower_path(tower.condo, tower)
  end

  it 'successfully' do
    user = create :manager
    condo = create :condo, name: 'Condomínio A'
    tower = create :tower, condo:, name: 'Torre A'
    tower.generate_floors

    create :unit_type, description: 'Apartamento de 1 quarto'
    create :unit_type, description: 'Apartamento de 2 quartos'

    login_as user, scope: :manager
    visit edit_floor_units_condo_tower_path(tower.condo, tower)

    within '#unit-1' do
      select 'Apartamento de 2 quartos', from: 'Unidade modelo 1'
    end

    within '#unit-2' do
      select 'Apartamento de 1 quarto', from: 'Unidade modelo 2'
    end

    within '#unit-3' do
      select 'Apartamento de 2 quartos', from: 'Unidade modelo 3'
    end

    within '#unit-4' do
      select 'Apartamento de 1 quarto', from: 'Unidade modelo 4'
    end

    click_on 'Atualizar Pavimento Tipo'

    expect(current_path).to eq tower_path tower
    expect(page).to have_content 'Pavimento Tipo atualizado com sucesso'
    expect(page).to have_content 'Torre A'
    expect(tower.floors.first.units.first.unit_type.description).to eq 'Apartamento de 2 quartos'
    expect(tower.floors.first.units.last.unit_type.description).to eq 'Apartamento de 1 quarto'
    expect(page).not_to have_link <<~HEREDOC.strip
      Cadastro do(a) #{tower.name} do(a) #{tower.condo.name} incompleto(a), por favor, atualize o pavimento tipo
    HEREDOC
  end

  it 'and fails if there is unselected unit types' do
    user = create :manager
    tower = create :tower
    tower.generate_floors

    create :unit_type, description: 'Apartamento de 1 quarto'
    create :unit_type, description: 'Apartamento de 2 quartos'

    login_as user, scope: :manager
    visit edit_floor_units_condo_tower_path(tower.condo, tower)

    within '#unit-1' do
      select 'Tipo de Unidade', from: 'Unidade modelo 1'
    end

    within '#unit-2' do
      select 'Tipo de Unidade', from: 'Unidade modelo 2'
    end

    within '#unit-3' do
      select 'Tipo de Unidade', from: 'Unidade modelo 3'
    end

    click_on 'Atualizar Pavimento Tipo'

    expect(page).to have_content 'Defina o tipo de unidade para todas as unidades'
  end

  context 'see a warning if registration is not complete' do
    it 'on root path' do
      user = create :manager
      condo = create :condo, name: 'Condomínio A'
      tower = create :tower, condo:, name: 'Torre B'
      tower.generate_floors

      login_as user, scope: :manager
      visit root_path

      expect(page).to have_link <<~HEREDOC.strip
        Cadastro do(a) #{tower.name} do(a) #{condo.name} incompleto(a), por favor, atualize o pavimento tipo
      HEREDOC
    end

    it 'and go to floor type registration page after clicked the warning link' do
      user = create :manager
      condo = create :condo, name: 'Condomínio A'
      tower = create :tower, condo:, name: 'Torre B'
      tower.generate_floors

      login_as user, scope: :manager
      visit root_path
      click_on <<~HEREDOC.strip
        Cadastro do(a) #{tower.name} do(a) #{condo.name} incompleto(a), por favor, atualize o pavimento tipo
      HEREDOC

      expect(current_path).to eq edit_floor_units_condo_tower_path(condo, tower)
      expect(page).to have_content 'Atualizar Pavimento Tipo do(a) Torre B'
      expect(page).not_to have_link <<~HEREDOC.strip
        Cadastro do(a) #{tower.name} do(a) #{condo.name} incompleto(a), por favor, atualize o pavimento tipo
      HEREDOC
    end

    it 'on tower details page' do
      user = create :manager
      condo = create :condo, name: 'Condomínio A'
      tower = create :tower, condo:, name: 'Torre B'
      tower.generate_floors

      login_as user, scope: :manager
      visit tower_path tower

      expect(page).to have_link <<~HEREDOC.strip
        Cadastro do(a) #{tower.name} do(a) #{condo.name} incompleto(a), por favor, atualize o pavimento tipo
      HEREDOC
    end

    it 'only if authenticated' do
      condo = create :condo, name: 'Condomínio A'
      tower = create :tower, condo:, name: 'Torre B'
      tower.generate_floors

      visit root_path

      expect(page).not_to have_link <<~HEREDOC.strip
        Cadastro do(a) #{tower.name} do(a) #{condo.name} incompleto(a), por favor, atualize o pavimento tipo
      HEREDOC
    end
  end
end
