require 'rails_helper'

describe 'Administrator edit floor type' do
  it 'only if authenticated' do
    tower = create :tower
    create :unit_type, description: 'Apartamento de 1 quarto'
    create :unit_type, description: 'Apartamento de 2 quartos'

    visit edit_floor_units_condo_tower_path(tower.condo, tower)

    expect(current_path).to eq new_manager_session_path
  end

  it 'successfully' do
    user = create :manager
    condo = create :condo, name: 'Condomínio A'
    tower = create :tower, condo:, name: 'Torre A'

    create :unit_type, condo:, description: 'Apartamento de 1 quarto'
    create :unit_type, condo:, description: 'Apartamento de 2 quartos'

    login_as user, scope: :manager
    visit tower_path tower
    click_on 'Editar Pavimento Tipo'

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

    expect(page).to have_current_path tower_path(tower), wait: 2
    expect(page).to have_content 'Pavimento Tipo atualizado com sucesso'
    expect(page).to have_content 'Torre A'
    expect(tower.floors.first.units.first.unit_type.description).to eq 'Apartamento de 2 quartos'
    expect(tower.floors.first.units.last.unit_type.description).to eq 'Apartamento de 1 quarto'
    expect(page).not_to have_link 'Cadastro do(a) Condomínio A do(a) Torre A incompleto(a), ' \
                                  'por favor, atualize o pavimento tipo'
  end

  it 'and fails if there is unselected unit types' do
    user = create :manager
    tower = create :tower

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
    it 'and go to floor type registration page after clicked the warning link' do
      user = create :manager
      condo = create :condo, name: 'Condomínio A'
      tower = create :tower, condo:, name: 'Torre B'

      login_as user, scope: :manager
      visit root_path
      click_on 'Cadastro do(a) Torre B do(a) Condomínio A incompleto(a), ' \
               'por favor, atualize o pavimento tipo'

      expect(current_path).to eq edit_floor_units_condo_tower_path(condo, tower)
      expect(page).to have_content 'Atualizar Pavimento Tipo do(a) Torre B'
      expect(page).not_to have_link 'Cadastro do(a) Torre B do(a) Condomínio A incompleto(a), ' \
                                    'por favor, atualize o pavimento tipo'
    end

    it 'on tower details page' do
      user = create :manager
      condo = create :condo, name: 'Condomínio A'
      tower = create :tower, condo:, name: 'Torre B'

      login_as user, scope: :manager
      visit tower_path tower

      expect(page).to have_link 'Cadastro do(a) Torre B do(a) Condomínio A incompleto(a), ' \
                                'por favor, atualize o pavimento tipo'
    end

    it 'only if authenticated' do
      condo = create :condo, name: 'Condomínio A'
      create :tower, condo:, name: 'Torre B'

      visit root_path

      expect(page).not_to have_link 'Cadastro do(a) Torre B do(a) Condomínio A incompleto(a), ' \
                                    'por favor, atualize o pavimento tipo'
    end
  end
end
