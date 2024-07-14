require 'rails_helper'

describe 'Super Manager registers new manager' do
  context 'from the menu' do
    it 'successfully' do
      manager = create :manager, is_super: true

      login_as manager, scope: :manager
      visit root_path
      within 'nav' do
        click_on id: 'side-menu'
        click_on 'Gerenciar usuarios'
        click_on 'Cadastrar novo administrador'
      end
      fill_in 'Nome Completo', with: 'Erika Campos'
      fill_in 'CPF', with: CPF.generate(format: true)
      fill_in 'E-mail', with: 'admin@email.com'
      fill_in 'Senha', with: 'password'
      attach_file 'Foto', Rails.root.join('spec/support/images/manager_photo.jpg')
      check 'Super Administrador'
      click_on 'Cadastrar'

      expect(page).to have_content 'Administrador cadastrado com sucesso - Nome: Erika Campos | Email: admin@email.com'
      expect(Manager.last.is_super).to be true
    end

    it 'with incomplete data' do
      manager = create :manager, is_super: true

      login_as manager, scope: :manager
      visit root_path
      within 'nav' do
        click_on id: 'side-menu'
        click_on 'Gerenciar usuarios'
        click_on 'Cadastrar novo administrador'
      end
      fill_in 'Nome Completo', with: ''
      fill_in 'CPF', with: ''
      click_on 'Cadastrar'

      expect(page).to have_content 'Não foi possível cadastrar novo administrador'
      expect(page).to have_content 'Nome Completo não pode ficar em branco'
      expect(page).to have_content 'CPF não pode ficar em branco'
    end

    it 'and must be authenticated' do
      visit new_manager_path

      expect(current_path).to eq new_manager_session_path
    end

    it 'and must be authenticated as Super Manager' do
      condo_manager = create :manager, is_super: false
      condo = create :condo
      condo.managers << condo_manager

      login_as condo_manager, scope: :manager
      visit root_path
      within 'nav' do
        click_on id: 'side-menu'
        click_on 'Gerenciar usuarios'
      end

      within 'nav' do
        expect(page).not_to have_link 'Cadastrar novo administrador'
      end
    end
  end

  context 'and delegate a condo to new manager' do
    it 'successfully' do
      super_manager = create :manager, is_super: true
      create :manager, full_name: 'Danilo Ribeiro', email: 'danilo@email.com', is_super: false
      create :manager, full_name: 'Rafael Ribeiro', email: 'rafael@email.com', is_super: false
      condo = create :condo, name: 'Condomínio A'

      login_as super_manager, scope: :manager
      visit condo_path(condo)
      click_on 'Adicionar Administrador'
      select 'Rafael Ribeiro', from: 'Selecionar Administrador'
      click_on 'Adicionar'

      expect(current_path).to eq condo_path(condo)
      expect(page).to have_content 'Administrador adicionado com sucesso'
      expect(Manager.last.condos.last.name).to eq condo.name
    end

    it 'and manager is already delegated' do
      super_manager = create :manager, is_super: true
      condo_manager = create :manager, full_name: 'Danilo Ribeiro', email: 'danilo@email.com', is_super: false
      create :manager, full_name: 'Rafael Ribeiro', email: 'rafael@email.com', is_super: false
      condo = create :condo, name: 'Condomínio A'

      condo.managers << condo_manager
      login_as super_manager, scope: :manager
      visit condo_path(condo)
      click_on 'Adicionar Administrador'

      within '#associate_manager_condo' do
        expect(page).not_to have_select 'manager_id', with_options: ['Danilo Ribeiro']
        expect(page).to have_select 'manager_id', with_options: ['Rafael Ribeiro']
      end
    end
  end
end
