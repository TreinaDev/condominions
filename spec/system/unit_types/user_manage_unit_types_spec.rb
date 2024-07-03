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
      fill_in 'Fração Ideal', with: '3'
      click_on 'Criar Tipo de unidade'

      expect(page).to have_content('Tipo de unidade cadastrado com sucesso')
      expect(current_path).to eq condo_unit_type_path(Condo.last, UnitType.last)
      expect(page).to have_content('Descrição: Apartamento de 2 quartos')
      expect(page).to have_content('Metragem: 50.0m²')
      expect(page).to have_content('Fração Ideal: 3%')
    end

    it 'with missing parameters' do
      user = create(:manager)
      login_as user, scope: :manager
      condo = create(:condo, name: 'Condomínio dos rubinhos')
      visit new_condo_unit_type_path(condo)

      click_on 'Criar Tipo de unidade'

      expect(page).to have_content('Erro ao cadastrar tipo de unidade')
      expect(page).to have_content('Descrição não pode ficar em branco')
      expect(page).to have_content('Metragem não pode ficar em branco')
      expect(page).to have_content('Fração Ideal não pode ficar em branco')
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

    it 'metreage cannot be zero or less' do
      condo = create(:condo, name: 'Condomínio dos rubinhos')
      user = create(:manager)
      login_as user, scope: :manager
      visit new_condo_unit_type_path(condo)

      fill_in 'Descrição',	with: 'Apartamento de 2 quartos'
      fill_in 'Metragem',	with: '0'
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
      unit_type = UnitType.create!(description: 'Apartamento de 50 quartos', metreage: 5, fraction: 3)

      visit condo_unit_type_path(condo, unit_type)

      expect(page).to have_link('Editar')
    end

    it 'succesfully' do
      condo = create(:condo, name: 'Condomínio dos rubinhos')
      user = create(:manager)
      login_as user, scope: :manager
      unit_type = UnitType.create!(description: 'Apartamento de 50 quartos', metreage: 5, fraction: 3)

      visit edit_condo_unit_type_path(condo, unit_type)
      fill_in 'Descrição',	with: 'Apartamento de 2 quartos'
      fill_in 'Metragem',	with: '50'
      fill_in 'Fração Ideal',	with: '2'
      click_on 'Atualizar Tipo de unidade'

      expect(current_path).to eq condo_unit_type_path(condo, unit_type)
      expect(page).to have_content('Tipo de unidade atualizado com sucesso')
      expect(page).to have_content('Descrição: Apartamento de 2 quartos')
      expect(page).to have_content('Metragem: 50.0m²')
      expect(page).to have_content('Fração Ideal: 2%')
    end

    it 'with missing params' do
      condo = create(:condo, name: 'Condomínio dos rubinhos')
      user = create(:manager)
      login_as user, scope: :manager
      unit_type = create(:unit_type)

      visit edit_condo_unit_type_path(condo, unit_type)
      fill_in 'Descrição', with: ''
      fill_in 'Metragem',	with: ''
      fill_in 'Fração Ideal',	with: ''
      click_on 'Atualizar Tipo de unidade'

      expect(current_path).to eq edit_condo_unit_type_path(condo, unit_type)
      expect(page).to have_content('Erro ao atualizar tipo de unidade')
      expect(page).to have_content('Descrição não pode ficar em branco')
      expect(page).to have_content('Metragem não pode ficar em branco')
      expect(page).to have_content('Fração Ideal não pode ficar em branco')
    end
  end
end
