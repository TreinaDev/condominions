require 'rails_helper'

describe 'User manage unit types' do
  context 'User register new unit type' do
    it 'sucessfully' do
      visit new_unit_type_path

      fill_in 'Descrição',	with: 'Apartamento de 2 quartos'
      fill_in 'Metragem',	with: '50'
      click_on 'Criar Tipo de unidade'

      expect(page).to have_content('Tipo de unidade cadastrado com sucesso')
      expect(current_path).to eq unit_type_path(UnitType.last)
      expect(page).to have_content('Descrição: Apartamento de 2 quartos')
      expect(page).to have_content('Metragem: 50.0m²')
    end

    it 'with missing parameters' do
      visit new_unit_type_path

      click_on 'Criar Tipo de unidade'

      expect(page).to have_content('Erro ao cadastrar tipo de unidade')
      expect(page).to have_content('Descrição não pode ficar em branco')
      expect(page).to have_content('Metragem não pode ficar em branco')
    end

    it 'and access from navbar' do
      user = create(:manager)
      login_as user, scope: :manager

      visit root_path
      within('nav') do
        click_on id: 'side-menu'
        click_on 'Criar Tipo de unidade'
      end

      expect(current_path).to eq new_unit_type_path
      expect(page).to have_content('Cadastrar um novo tipo de unidade')
    end

    it 'metreage cannot be zero or less' do
      visit new_unit_type_path

      fill_in 'Descrição',	with: 'Apartamento de 2 quartos'
      fill_in 'Metragem',	with: '0'
      click_on 'Criar Tipo de unidade'

      expect(page).to have_content('Erro ao cadastrar tipo de unidade')
      expect(page).to have_content('Metragem deve ser maior que 0')
    end
  end

  context 'User edit an unit type' do
    it 'from unit type details page' do
      unit_type = UnitType.create!(description: 'Apartamento de 50 quartos', metreage: 5)

      visit unit_type_path(unit_type)

      expect(page).to have_link('Editar')
    end

    it 'succesfully' do
      unit_type = UnitType.create!(description: 'Apartamento de 50 quartos', metreage: 5)

      visit edit_unit_type_path(unit_type)
      fill_in 'Descrição',	with: 'Apartamento de 2 quartos'
      fill_in 'Metragem',	with: '50'
      click_on 'Atualizar Tipo de unidade'

      expect(current_path).to eq unit_type_path(unit_type)
      expect(page).to have_content('Tipo de unidade atualizado com sucesso')
      expect(page).to have_content('Descrição: Apartamento de 2 quartos')
      expect(page).to have_content('Metragem: 50.0m²')
    end

    it 'with missing params' do
      unit_type = create(:unit_type)

      visit edit_unit_type_path(unit_type)
      fill_in 'Descrição',	with: ''
      fill_in 'Metragem',	with: ''
      click_on 'Atualizar Tipo de unidade'

      expect(current_path).to eq edit_unit_type_path(unit_type)
      expect(page).to have_content('Erro ao atualizar tipo de unidade')
      expect(page).to have_content('Descrição não pode ficar em branco')
      expect(page).to have_content('Metragem não pode ficar em branco')
    end
  end
end
