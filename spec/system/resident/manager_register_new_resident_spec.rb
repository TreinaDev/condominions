require 'rails_helper'

describe 'Manager registers new resident' do
  it 'from the menu' do
    manager = create :manager
    create :condo, name: 'Condominio Errado'
    condo = create :condo, name: 'Condominio Certo'
    create :tower, 'condo' => condo, name: 'Torre errada'
    create :tower, 'condo' => condo, name: 'Torre correta', floor_quantity: 2, units_per_floor: 2

    mail = double 'mail', deliver: true
    mailer_double = double 'ResidentMailer', notify_new_resident: mail

    allow(ResidentMailer).to receive(:with).and_return mailer_double
    allow(mailer_double).to receive(:notify_new_resident).and_return mail

    login_as manager, scope: :manager
    visit root_path
    within 'nav' do
      click_on id: 'side-menu'
      click_on 'Gerenciar Usuários'
      click_on 'Cadastrar Morador'
    end

    fill_in 'Nome Completo', with: 'Adroaldo Junior'
    fill_in 'CPF',	with: CPF.generate(format: true)
    fill_in 'E-mail',	with: 'adroaldo@email.com'
    select 'Proprietário', from: 'Tipo de Morador'
    select 'Condominio Certo', from: 'Condomínio'
    select 'Torre correta', from: 'Torre'
    select '2', from: 'Andar'
    select '1', from: 'Unidade'
    click_on 'Enviar'

    expect(page).to have_content 'Convite enviado com sucesso para Adroaldo Junior (adroaldo@email.com)'
    expect(Resident.last.full_name).to eq 'Adroaldo Junior'
    expect(Resident.last.status).to eq 'not_confirmed'
    expect(mail).to have_received(:deliver).once
  end

  it 'must be authenticated' do
    visit new_resident_path

    expect(current_path).to eq new_manager_session_path
  end

  it 'and can only be authenticated as a manager' do
    resident = create :resident

    login_as resident, scope: :resident
    visit new_resident_path

    expect(current_path).to eq root_path
  end

  it 'with incomplete data' do
    manager = create :manager

    login_as manager, scope: :manager
    visit root_path

    within 'nav' do
      click_on id: 'side-menu'
      click_on 'Gerenciar Usuários'
      click_on 'Cadastrar Morador'
    end

    fill_in 'Nome Completo', with: ''
    fill_in 'CPF',	with: ''
    fill_in 'E-mail',	with: ''
    click_on 'Enviar'

    expect(page).to have_content 'Nome Completo não pode ficar em branco'
    expect(page).to have_content 'CPF inválido'
    expect(page).to have_content 'Unidade é obrigatório(a)'
  end
end
