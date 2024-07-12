require 'rails_helper'

describe 'User manage unit types' do
  context 'User register new unit type' do
    it 'sucessfully' do
      user = create(:manager)
      create(:condo, name: 'Condomínio dos rubinhos')
      login_as user, scope: :manager

      visit root_path
      within 'nav' do
        click_on id: 'side-menu'
        click_on 'Criar Tipo de Unidade'
      end
      within '#condoSelectPopupForUnitTypes' do
        click_on 'Condomínio dos rubinhos'
      end
      fill_in 'Descrição',	with: 'Apartamento de 2 quartos'
      fill_in 'Metragem',	with: '50'
      click_on 'Criar Tipo de unidade'

      expect(page).to have_content('Tipo de unidade cadastrado com sucesso')
      expect(current_path).to eq unit_type_path UnitType.last
      expect(page).to have_content('Descrição: Apartamento de 2 quartos')
      expect(page).to have_content('Metragem: 50.0m²')
      expect(page).to have_content('Fração Ideal: Não definida')
    end

    it 'with missing parameters' do
      user = create(:manager)
      login_as user, scope: :manager
      condo = create(:condo)
      visit new_condo_unit_type_path(condo)

      click_on 'Criar Tipo de unidade'

      expect(page).to have_content('Erro ao cadastrar tipo de unidade')
      expect(page).to have_content('Descrição não pode ficar em branco')
      expect(page).to have_content('Metragem não pode ficar em branco')
    end

    it 'and access from navbar' do
      user = create(:manager)
      login_as user, scope: :manager
      condo = create(:condo, name: 'Condomínio dos rubinhos')

      visit root_path
      within('nav') do
        click_on id: 'side-menu'
        click_on 'Criar Tipo de Unidade'
      end

      within '#condoSelectPopupForUnitTypes' do
        click_on 'Condomínio dos rubinhos'
      end

      expect(current_path).to eq new_condo_unit_type_path(condo)
      expect(page).to have_content('Cadastrar um novo tipo de unidade')
    end

    it 'metreage have to be bigger than 0' do
      condo = create(:condo, name: 'Condomínio dos rubinhos')
      user = create(:manager)
      login_as user, scope: :manager
      visit new_condo_unit_type_path(condo)

      fill_in 'Descrição',	with: 'Apartamento de 2 quartos'
      fill_in 'Metragem',	with: '-1'
      click_on 'Criar Tipo de unidade'

      expect(page).to have_content('Erro ao cadastrar tipo de unidade')
      expect(page).to have_content('Metragem deve ser maior que 0')
    end
  end

  context 'User edit an unit type' do
    it 'from unit type details page' do
      condo = create(:condo, name: 'Condomínio dos rubinhos')
      user = create(:manager)
      login_as user, scope: :manager
      unit_type = UnitType.create!(description: 'Apartamento de 50 quartos',
                                   metreage: 5,
                                   condo_id: condo.id)

      visit unit_type_path unit_type

      expect(page).to have_link('Editar')
    end

    it 'successfully when is not related to a tower' do
      condo = create(:condo)
      user = create(:manager)
      unit_type = UnitType.create!(description: 'Apartamento de 50 quartos',
                                   metreage: 5,
                                   condo_id: condo.id)

      login_as user, scope: :manager
      visit edit_unit_type_path unit_type
      fill_in 'Descrição',	with: 'Apartamento de 2 quartos'
      fill_in 'Metragem',	with: '50'
      click_on 'Atualizar Tipo de unidade'

      expect(current_path).to eq unit_type_path unit_type
      expect(page).to have_content('Tipo de unidade atualizado com sucesso')
      expect(page).to have_content('Descrição: Apartamento de 2 quartos')
      expect(page).to have_content('Metragem: 50.0m²')
      expect(page).to have_content('Fração Ideal: Não definida')
    end

    it 'succesfully when is related to a tower' do
      condo = create(:condo)
      first_unit_type = UnitType.create!(description: 'Apartamento de 1 quartos', metreage: 5, condo_id: condo.id)
      second_unit_type = UnitType.create!(description: 'Apartamento de 2 quartos', metreage: 150, condo_id: condo.id)
      create(:tower, :with_four_units, floor_quantity: 5, condo:, unit_types: [first_unit_type, second_unit_type])
      user = create(:manager)

      login_as user, scope: :manager
      visit edit_unit_type_path first_unit_type
      fill_in 'Metragem',	with: '50'
      click_on 'Atualizar Tipo de unidade'

      expect(page).to have_content('Tipo de unidade atualizado com sucesso')
      expect(current_path).to eq unit_type_path first_unit_type
      expect(page).to have_content('Descrição: Apartamento de 1 quartos')
      expect(page).to have_content('Metragem: 50.0m²')
      expect(page).to have_content('Fração Ideal: 2.5%')
    end

    it 'with missing params' do
      create(:condo)
      user = create(:manager)
      login_as user, scope: :manager
      unit_type = create(:unit_type)

      visit edit_unit_type_path unit_type
      fill_in 'Descrição', with: ''
      fill_in 'Metragem',	with: ''
      click_on 'Atualizar Tipo de unidade'

      expect(current_path).to eq edit_unit_type_path unit_type
      expect(page).to have_content('Erro ao atualizar tipo de unidade')
      expect(page).to have_content('Descrição não pode ficar em branco')
      expect(page).to have_content('Metragem não pode ficar em branco')
    end
  end
end
