require 'rails_helper'

describe 'Manager register superintendent' do
  it 'Successfully' do
    condo = create :condo, name: 'Condomínio X'
    resident = create(:resident, :with_residence, full_name: 'Alvus Dumbledore', condo:)
    manager = create :manager
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
    click_on 'Enviar'

    expect(page).to have_content 'Mandato de síndico cadastro com sucesso!'
    expect(current_path).to eq condo_superintendent_path(condo, Superintendent.last)
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
    click_on 'Enviar'

    expect(page).to have_content 'Não foi possível cadastrar o mandato.'
    expect(page).to have_content 'Data de ínicio não pode ficar em branco'
    expect(page).to have_content 'Data de conclusão não pode ficar em branco'
    expect(page).to have_content 'Morador é obrigatório'
    expect(Superintendent.count).to eq 0
  end

  it 'and condo has superintedent' do
    condo = create :condo, name: 'Condomínio X'
    superintendent = create(:superintendent, condo:)
    resident = superintendent.tenant
    manager = create :manager

    resident.user_image.attach(io: Rails.root.join('spec/support/images/resident_photo.jpg').open,
                               filename: 'resident_photo.jpg')

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

    expect(current_path).to eq condo_superintendent_path(condo, superintendent)
    expect(page).to have_content 'Esse condomínio já possui um síndico cadastrado!'
  end
end
