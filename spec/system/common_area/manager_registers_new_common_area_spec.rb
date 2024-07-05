require 'rails_helper'

describe 'Manager registers new common area' do
  it 'and access from nav bar' do
    manager = create(:manager)
    condo = create(:condo, name: 'Condomínio dos rubinhos')

    login_as(manager, scope: :manager)
    visit root_path
    within 'nav' do
      click_on id: 'side-menu'
      click_on 'Criar Área Comum'
    end
    within '#condoSelectPopupForCommonAreas' do
      click_on 'Condomínio dos rubinhos'
    end

    expect(current_path).to eq new_condo_common_area_path(condo)
  end

  it 'successfully' do
    manager = create(:manager)
    condo = create(:condo)

    login_as(manager, scope: :manager)
    visit new_condo_common_area_path(condo)
    fill_in 'Nome', with: 'Salão de Festas'
    fill_in 'Descrição', with: 'Realize sua festa em nosso salão de festas'
    fill_in 'Capacidade Máxima', with: 100
    fill_in 'Regras de Uso', with: 'Salão de festas não pode ser utilizado após as 22 horas'
    click_on 'Salvar'

    expect(page).to have_content 'Área comum cadastrada com sucesso'
    expect(page).to have_content 'Salão de Festas'
    expect(page).to have_content 'Descrição: Realize sua festa em nosso salão de festas'
    expect(page).to have_content 'Capacidade Máxima: 100 pessoas'
    expect(page).to have_content 'Regras de Uso: Salão de festas não pode ser utilizado após as 22 horas'
  end

  it 'with incomplete data' do
    manager = create(:manager)
    condo = create(:condo)

    login_as(manager, scope: :manager)
    visit new_condo_common_area_path(condo)
    fill_in 'Nome', with: ''
    fill_in 'Descrição', with: ''
    fill_in 'Capacidade Máxima', with: ''
    click_on 'Salvar'

    expect(page).to have_content 'Não foi possível cadastrar área comum'
    expect(page).to have_content 'Nome não pode ficar em branco'
    expect(page).to have_content 'Descrição não pode ficar em branco'
    expect(page).to have_content 'Capacidade Máxima não pode ficar em branco'
  end

  it 'and must be authenticated' do
    condo = create(:condo)

    visit new_condo_common_area_path(condo)

    expect(current_path).to eq new_manager_session_path
  end

  it 'and can only view the common area details if authenticated' do
    common_area = create(:common_area)

    visit common_area_path(common_area)

    expect(current_path).to eq signup_choice_path
    expect(page).to have_content 'Você deve estar autenticado para continuar'
  end
end
