require 'rails_helper'

describe 'Manager register superintendent' do
  it 'Successfully' do
    condo = create :condo, name: 'Condomínio X'
    tower = create(:tower, condo:)
    unit11 = tower.floors.first.units.first
    manager = create :manager
    resident = create :resident, full_name: 'Alvus Dumbledore', residence: unit11
    date = Time.zone.today

    login_as manager, scope: :manager
    visit root_path
    within 'nav' do
      click_on id: 'side-menu'
      click_on 'Gerenciar Usuários'
      click_on 'Cadastrar Síndico'
    end
    within '#condoSelectPopupForSuperintendent' do
      click_on 'Condomínio X'
    end
    fill_in 'Data de ínicio', with: date
    fill_in 'Data de conclusão', with: date >> 12
    select 'Alvus Dumbledore', from: 'Morador'
    click_on 'Cadastrar Gestão'

    expect(page).to have_content 'Mandato de síndico cadastro com sucesso!'
    expect(current_path).to eq superintendent_path Superintendent.last
    expect(Superintendent.last.tenant).to eq resident
  end

  it 'with blank fields' do
    condo = create :condo, name: 'Condomínio X'
    create(:tower, condo:)
    manager = create :manager

    login_as manager, scope: :manager
    visit root_path
    within 'nav' do
      click_on id: 'side-menu'
      click_on 'Gerenciar Usuários'
      click_on 'Cadastrar Síndico'
    end
    within '#condoSelectPopupForSuperintendent' do
      click_on 'Condomínio X'
    end
    fill_in 'Data de ínicio', with: ''
    fill_in 'Data de conclusão', with: ''
    click_on 'Cadastrar Gestão'

    expect(page).to have_content 'Não foi possível cadastrar o mandato.'
    expect(page).to have_content 'Data de ínicio não pode ficar em branco'
    expect(page).to have_content 'Data de conclusão não pode ficar em branco'
    expect(page).to have_content 'Morador é obrigatório'
    expect(Superintendent.count).to eq 0
  end
end
