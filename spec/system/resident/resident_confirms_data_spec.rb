require 'rails_helper'

describe 'Resident confirms data' do
  it 'and see registered data' do
    condo = create :condo, name: 'Condominio Certo'
    tower = create :tower, 'condo' => condo, name: 'Torre correta', floor_quantity: 2, units_per_floor: 4
    tower.generate_floors
    first_floor = tower.floors[0]
    third_unit = first_floor.units[2]

    resident = create :resident, unit: third_unit, full_name: 'Jessica Brito', registration_number: '163.289.380-04',
                                 status: :not_confirmed, resident_type: :owner, email: 'jessica@email.com',
                                 password: '123456'

    login_as resident, scope: :resident
    visit root_path

    expect(current_path).to eq confirm_resident_path(resident)
    expect(page).to have_field 'Nome Completo', with: 'Jessica Brito', disabled: true
    expect(page).to have_field 'CPF', with: '163.289.380-04', disabled: true
    expect(page).to have_field 'E-mail', with: 'jessica@email.com', disabled: true
    expect(page).to have_field 'Tipo de Morador', with: 'Proprietário', disabled: true
    expect(page).to have_field 'Condomínio', with: 'Condominio Certo', disabled: true
    expect(page).to have_field 'Torre', with: 'Torre correta', disabled: true
    expect(page).to have_field 'Andar', with: '1', disabled: true
    expect(page).to have_field 'Unidade', with: '13', disabled: true
    expect(page).to have_content 'Foto'
    expect(page).to have_field 'Senha', with: ''
    expect(page).to have_field 'Confirmar Senha', with: ''
    expect(page).to have_button 'Confirmar Dados'
    expect(page).to have_button 'Solicitar Alteração de Dados'
  end

  it 'and resetting password is mandatory' do
    resident = create :resident, password: '123456', status: :not_confirmed

    login_as resident, scope: :resident
    visit root_path
    click_on 'Confirmar Dados'

    expect(resident.status).to eq 'not_confirmed'
    expect(page).to have_content 'Senha não pode ficar em branco'
  end

  it 'and password confirmation does not match password' do
    resident = create :resident, password: '123456', status: :not_confirmed

    login_as resident, scope: :resident
    visit root_path
    fill_in 'Senha', with: '12ab56'
    fill_in 'Confirmar Senha', with: '353456ae'
    click_on 'Confirmar Dados'

    expect(resident.status).to eq 'not_confirmed'
    expect(page).to have_content 'Confirmar Senha deve ser igual a senha'
  end

  it 'and new password cannot be the same as the current password' do
    resident = create :resident, password: '123456', status: :not_confirmed

    login_as resident, scope: :resident
    visit root_path
    fill_in 'Senha', with: '123456'
    fill_in 'Confirmar Senha', with: '123456'
    click_on 'Confirmar Dados'

    expect(resident.status).to eq 'not_confirmed'
    expect(page).to have_content 'Senha deve ser diferente da atual'
  end

  it 'successfully' do
    resident = create :resident, password: '123456', status: :not_confirmed

    login_as resident, scope: :resident
    visit root_path
    attach_file 'Foto', Rails.root.join('spec/support/images/resident_photo.jpg')
    fill_in 'Senha', with: 'teste123'
    fill_in 'Confirmar Senha', with: 'teste123'
    click_on 'Confirmar Dados'

    expect(page).to have_content 'Conta atualizada com sucesso!'
    expect(page).to have_css 'img[src*="resident_photo.jpg"]'
    resident.reload
    expect(resident.confirmed?).to eq true
  end

  it 'is encouraged to upload a photo' do
    resident = create :resident, password: '123456', status: :confirmed

    login_as resident, scope: :resident
    visit root_path

    expect(page).to have_content 'Por favor, cadastre sua foto'
  end
end
