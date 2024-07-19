require 'rails_helper'

describe 'Manager edits common area' do
  it 'and must be authenticated' do
    common_area = create :common_area

    visit edit_common_area_path common_area

    expect(current_path).to eq new_manager_session_path
  end

  it 'and does not see edit button if is a resident' do
    common_area = create :common_area
    resident = create :resident, :with_residence, condo: common_area.condo

    login_as resident, scope: :resident
    visit common_area_path common_area

    expect(page).not_to have_link 'Editar'
  end

  it 'successfully' do
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

    expect(page).to have_content 'Não foi possível atualizar área comum'
    expect(page).to have_content 'Nome não pode ficar em branco'
    expect(page).to have_content 'Descrição não pode ficar em branco'
    expect(page).to have_content 'Capacidade Máxima não pode ficar em branco'
  end
end
