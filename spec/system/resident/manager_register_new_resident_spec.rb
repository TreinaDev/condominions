require 'rails_helper'

describe 'Manager registers new resident' do
  it 'from the menu' do
    manager = create :manager

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
    click_on 'Enviar'

    expect(page).to have_content 'Residente cadastrado com sucesso'
    expect(Resident.last.full_name).to eq 'Adroaldo Junior'
    expect(current_path).to eq new_resident_owner_path Resident.last
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
  end

  it 'and theres already a resident' do
    manager = create :manager
    condo = create :condo, name: 'Condominio A'
    tower = create :tower, 'condo' => condo, name: 'Torre A', floor_quantity: 2, units_per_floor: 2
    unit11 = tower.floors[0].units[0]
    resident = create :resident, :mail_confirmed, full_name: 'Adroaldo Silva', properties: [unit11],
                                                  email: 'adroaldo@email.com', registration_number: '678.490.811-29'
    login_as manager, scope: :manager

    visit root_path

    within 'nav' do
      click_on id: 'side-menu'
      click_on 'Gerenciar Usuários'
      click_on 'Cadastrar Morador'
    end

    fill_in 'CPF',	with: '678.490.811-29'

    click_on 'Enviar'

    expect(page).to have_current_path resident_path(resident), wait: 3
    expect(page).to have_content 'Morador já cadastro, redirecionado para a página de detalhes do morador'
  end
end
