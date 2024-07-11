require 'rails_helper'

describe 'managers access page to set a resident as owner' do
  it 'and is not authenticated' do
    resident = create(:resident)

    visit new_resident_tenant_path resident

    expect(current_path).to eq new_manager_session_path
  end

  it 'and choose an existent unit from the flash message(success)' do
    manager = create :manager
    create :condo, name: 'Condominio Errado'
    condo = create :condo, name: 'Condominio Certo'
    create :tower, 'condo' => condo, name: 'Torre errada'
    tower = create :tower, 'condo' => condo, name: 'Torre correta', floor_quantity: 2, units_per_floor: 2
    tower.generate_floors
    resident = create(:resident, :not_owner, full_name: 'Adroaldo Silva')

    login_as manager, scope: :manager

    visit root_path
    click_on 'Cadastro de Adroaldo Silva incompleto, por favor, adicione unidades possuídas, caso haja, ou finalize o cadastro.'

    select 'Condominio Certo', from: 'Condomínio'
    select 'Torre correta', from: 'Torre'
    select '1', from: 'Andar'
    select '2', from: 'Unidade'
    click_on 'Adicionar Propriedade'

    expect(current_path).to eq new_resident_owner_path resident
    expect(page).to have_content 'Propriedade cadastrada com sucesso!'
    expect(page).to have_content 'Condomínio: Condominio Certo'
    expect(page).to have_content 'Torre: Torre correta'
    expect(page).to have_content 'Unidade: 12'
    resident.reload
    expect(resident.units.last.short_identifier).to eq '12'
  end

  it 'and choose an existent unit (success)' do
    manager = create :manager
    resident = create(:resident, :not_owner, full_name: 'Adroaldo Silva')

    mail = double 'mail', deliver: true
    mailer_double = double 'ResidentMailer', notify_new_resident: mail

    allow(ResidentMailer).to receive(:with).and_return mailer_double
    allow(mailer_double).to receive(:notify_new_resident).and_return mail

    login_as manager, scope: :manager

    visit root_path
    click_on 'Cadastro de Adroaldo Silva incompleto, por favor, adicione unidades possuídas, caso haja, ou finalize o cadastro.'

    click_on 'Finalizar Cadastro'

    expect(current_path).to eq root_path
    expect(mail).to have_received(:deliver).once
    expect(page).to have_content 'Cadastro finalizado com sucesso!'
    resident.reload
    expect(resident.mail_not_confirmed?).to eq true
  end

end
