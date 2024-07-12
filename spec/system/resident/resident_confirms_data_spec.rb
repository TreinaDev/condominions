require 'rails_helper'

describe 'Resident confirms data' do
  it 'and must have not_confirmed status' do
    resident = create :resident, status: :mail_confirmed

    login_as resident, scope: :resident
    visit confirm_resident_path resident

    expect(current_path).to eq root_path
  end

  it 'and see registered data and have residence and units' do
    create :condo, name: 'Condominio Errado'
    condo = create :condo, name: 'Condominio Certo'
    create :tower, 'condo' => condo, name: 'Torre errada', floor_quantity: 2, units_per_floor: 2
    tower = create :tower, 'condo' => condo, name: 'Torre correta', floor_quantity: 2, units_per_floor: 2
    resident = create :resident, full_name: 'Jessica Brito', registration_number: '163.289.380-04',
                                 status: :mail_not_confirmed, email: 'jessica@email.com'

    resident.residence = tower.floors[0].units[1]
    resident.units << tower.floors[0].units[1]
    resident.units << tower.floors[1].units[1]
    resident.save

    login_as resident, scope: :resident
    visit root_path

    expect(current_path).to eq confirm_resident_path resident
    expect(page).to have_content 'Nome Completo: Jessica Brito'
    expect(page).to have_content 'CPF: 163.289.380-04'
    expect(page).to have_content 'E-mail: jessica@email.com'
    within('.residence') do
      expect(page).to have_content 'Condomínio: Condominio Certo'
      expect(page).to have_content 'Torre: Torre correta'
      expect(page).to have_content 'Unidade: 12'
    end
    within('.units-array .unit:nth-of-type(1)') do
      expect(page).to have_content 'Condomínio: Condominio Certo'
      expect(page).to have_content 'Torre: Torre correta'
      expect(page).to have_content 'Unidade: 12'
    end
    within('.units-array .unit:nth-of-type(2)') do
      expect(page).to have_content 'Condomínio: Condominio Certo'
      expect(page).to have_content 'Torre: Torre correta'
      expect(page).to have_content 'Unidade: 22'
    end
    expect(page).to have_content 'Foto'
    expect(page).to have_button 'Confirmar Dados'
  end

  it 'and see registered data and have no residence nor units' do
    resident = create :resident, full_name: 'Jessica Brito', registration_number: '163.289.380-04',
                                 status: :mail_not_confirmed, email: 'jessica@email.com'

    login_as resident, scope: :resident
    visit root_path

    expect(current_path).to eq confirm_resident_path resident
    expect(page).to have_content 'Nome Completo: Jessica Brito'
    expect(page).to have_content 'CPF: 163.289.380-04'
    expect(page).to have_content 'E-mail: jessica@email.com'
    expect(page).to have_content 'Não possui propriedades no condomínio'
    expect(page).to have_content 'Não reside no condomínio'
    expect(page).to have_content 'Foto'
    expect(page).to have_button 'Confirmar Dados'
  end

  it 'successfully' do
    resident = create :resident, status: :mail_not_confirmed

    login_as resident, scope: :resident
    visit root_path
    attach_file 'Foto', Rails.root.join('spec/support/images/resident_photo.jpg')
    click_on 'Confirmar Dados'

    expect(page).to have_content 'Conta atualizada com sucesso!'
    expect(page).to have_css 'img[src*="resident_photo.jpg"]'
    resident.reload
    expect(resident.mail_confirmed?).to be true
  end

  it 'is encouraged to upload a photo' do
    resident = create :resident, status: :mail_confirmed

    login_as resident, scope: :resident
    visit root_path

    expect(page).to have_content 'Por favor, cadastre sua foto'
  end
end
