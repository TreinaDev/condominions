require 'rails_helper'

describe 'Manager edits common area' do
  it 'and sees breadcrumb' do
    manager = create(:manager)
    create :condo, name: 'Condominio Residencial Paineiras'
    common_area = create :common_area, name: 'Churrasqueira'

    login_as manager, scope: :manager
    visit edit_common_area_path common_area

    within 'ol.breadcrumb' do
      expect(page).to have_content 'Home'
      expect(page).to have_content 'Condomínios'
      expect(page).to have_content 'Condominio Residencial Paineiras'
      expect(page).to have_content 'Áreas Comuns'
      expect(page).to have_content 'Churrasqueira'
      expect(page).to have_content 'Editar'
    end
  end

  it 'succesfully' do
    manager = create(:manager)
    common_area = create(:common_area)

    login_as(manager, scope: :manager)
    visit common_area_path(common_area)
    click_on 'Editar'
    fill_in 'Nome', with: 'Churrasqueira'
    fill_in 'Capacidade Máxima', with: 30
    fill_in 'Descrição', with: 'Reuna a família em um churrasco'
    fill_in 'Regras de Uso', with: 'Deixe o espaço organizado após o uso'
    click_on 'Salvar'

    expect(page).to have_content 'Área comum atualizada com sucesso'
    expect(page).to have_content 'Churrasqueira'
    expect(page).to have_content 'Descrição: Reuna a família em um churrasco'
    expect(page).to have_content 'Capacidade Máxima: 30 pessoas'
    expect(page).to have_content 'Regras de Uso: Deixe o espaço organizado após o uso'
  end

  it 'with incomplete data' do
    manager = create(:manager)
    common_area = create(:common_area)

    login_as(manager, scope: :manager)
    visit common_area_path(common_area)
    click_on 'Editar'
    fill_in 'Nome', with: ''
    fill_in 'Capacidade Máxima', with: ''
    fill_in 'Descrição', with: ''
    click_on 'Salvar'

    within 'ol.breadcrumb' do
      expect(page).to have_content 'Home'
      expect(page).to have_content 'Condomínios'
      expect(page).to have_content 'Condominio Residencial Paineiras'
      expect(page).to have_content 'Áreas Comuns'
      expect(page).to have_content 'Salão de Festas'
      expect(page).to have_content 'Editar'
    end

    expect(page).to have_content 'Não foi possível atualizar área comum'
    expect(page).to have_content 'Nome não pode ficar em branco'
    expect(page).to have_content 'Descrição não pode ficar em branco'
    expect(page).to have_content 'Capacidade Máxima não pode ficar em branco'
  end

  it 'and must be authenticated' do
    common_area = create(:common_area)

    visit edit_common_area_path(common_area)

    expect(current_path).to eq new_manager_session_path
  end
end
