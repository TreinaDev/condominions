require 'rails_helper'

describe 'managers access page to set a resident as tenant' do
  it 'and is not authenticated' do
    resident = create :resident

    visit new_resident_tenant_path resident

    expect(current_path).to eq new_manager_session_path
  end

  it 'and choose an existent unit (success)' do
    manager = create :manager
    create :condo, name: 'Condominio Errado'
    condo = create :condo, name: 'Condominio Certo'
    create :tower, 'condo' => condo, name: 'Torre errada'
    create :tower, 'condo' => condo, name: 'Torre correta', floor_quantity: 2, units_per_floor: 2
    resident = create :resident, :not_tenant, full_name: 'Adroaldo Silva'

    mail = double 'mail', deliver: true
    mailer_double = double 'ResidentMailer', notify_new_resident: mail

    allow(ResidentMailer).to receive(:with).and_return mailer_double
    allow(mailer_double).to receive(:notify_new_resident).and_return mail

    login_as manager, scope: :manager

    visit root_path
    click_on 'Cadastro de Adroaldo Silva incompleto, por favor, ' \
             'indique a sua residência ou se não reside no condomínio.'

    select 'Condominio Certo', from: 'Condomínio'
    select 'Torre correta', from: 'Torre'
    select '1', from: 'Andar'
    select '2', from: 'Unidade'
    click_on 'Atualizar Morador'

    expect(current_path).to eq root_path
    expect(mail).to have_received(:deliver).once
    expect(page).to have_content 'Cadastro realizado com sucesso!'
    resident.reload
    expect(resident.residence).not_to eq nil
    expect(resident.mail_not_confirmed?).to eq true
  end

  it 'and resident does not live in condo' do
    manager = create :manager
    create :condo, name: 'Condominio Errado'
    condo = create :condo, name: 'Condominio Certo'
    create :tower, 'condo' => condo, name: 'Torre errada'
    create :tower, 'condo' => condo, name: 'Torre correta', floor_quantity: 2, units_per_floor: 2
    resident = create :resident, :not_tenant, full_name: 'Adroaldo Silva'

    login_as manager, scope: :manager

    visit root_path
    click_on 'Cadastro de Adroaldo Silva incompleto, por favor, ' \
             'indique a sua residência ou se não reside no condomínio.'

    click_on 'Não reside neste condomínio'

    expect(page).to have_content 'Cadastro realizado com sucesso!'
    expect(current_path).to eq root_path
    resident.reload
    expect(resident.residence).to eq nil
    expect(resident.mail_not_confirmed?).to eq true
  end

  it "and there's on unit selected (fail)" do
    manager = create :manager
    create :condo, name: 'Condominio Errado'

    resident = create :resident, :not_tenant, full_name: 'Adroaldo Silva'

    login_as manager, scope: :manager

    visit root_path
    click_on 'Cadastro de Adroaldo Silva incompleto, por favor, ' \
             'indique a sua residência ou se não reside no condomínio.'

    click_on 'Atualizar Morador'

    expect(current_path).to eq new_resident_tenant_path resident
    expect(page).to have_content 'Unidade não pode ficar em branco'
    resident.reload
    expect(resident.residence).to eq nil
    expect(resident.not_tenant?).to eq true
  end

  it 'and cannot set as tenant for an unit that already has an tenant' do
    manager = create :manager
    condo = create :condo, name: 'Condominio Certo'
    tower = create :tower, 'condo' => condo, name: 'Torre correta', floor_quantity: 2, units_per_floor: 2
    unit11 = tower.floors[0].units[0]
    create :resident, :mail_confirmed, full_name: 'Adroaldo Silva', residence: unit11, email: 'Adroaldo@email.com'
    resident = create :resident, :not_tenant, full_name: 'Sandra Soares'

    login_as manager, scope: :manager
    visit root_path
    click_on 'Cadastro de Sandra Soares incompleto, por favor, ' \
             'indique a sua residência ou se não reside no condomínio.'
    sleep 2
    select 'Condominio Certo', from: 'Condomínio'
    select 'Torre correta', from: 'Torre'
    select '1', from: 'Andar'
    select '1', from: 'Unidade'
    click_on 'Atualizar Morador'

    expect(current_path).to eq new_resident_tenant_path resident
    expect(page).to have_content 'Unidade já atribuída como residência de outro morador'
  end
end