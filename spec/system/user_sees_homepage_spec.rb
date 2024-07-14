require 'rails_helper'

describe 'User sees home page' do
  it 'and must be authenticated' do
    visit root_path

    expect(current_path).to eq signup_choice_path
  end

  it 'and sees a list of condos' do
    manager = create :manager
    create :condo, name: 'Residencial Horizonte Verde',
                   address: create(:address, public_place: 'Rua Principal', number: 100,
                                             neighborhood: 'Centro', city: 'São Paulo',
                                             state: 'SP', zip: '12345-678')
    create :condo, name: 'Condomínio Bela Vista',
                   address: create(:address, public_place: 'Avenida das Montanhas', number: 45,
                                             neighborhood: 'Vila Nova', city: 'Rio de Janeiro',
                                             state: 'RJ', zip: '45758-463')
    create :condo, name: 'Vila do Sol Nascente',
                   address: create(:address, public_place: 'Rua do Luar', number: 789,
                                             neighborhood: 'Jardim do Sol', city: 'Belo Horizonte',
                                             state: 'MG', zip: '14745-632')

    login_as manager, scope: :manager
    visit root_path

    expect(page).to have_content 'Residencial Horizonte Verde'
    expect(page).to have_content 'Endereço: Rua Principal, 100, Centro - São Paulo/SP - CEP: 12345-678'
    expect(page).to have_content 'Condomínio Bela Vista'
    expect(page).to have_content 'Endereço: Avenida das Montanhas, 45, Vila Nova - Rio de Janeiro/RJ - CEP: 45758-463'
    expect(page).to have_content 'Vila do Sol Nascente'
    expect(page).to have_content 'Endereço: Rua do Luar, 789, Jardim do Sol - Belo Horizonte/MG - CEP: 14745-632'
  end

  it 'and cannot see condos that he does not have access to' do
    condo_manager = create :manager, is_super: false
    first_condo = create :condo, name: 'Residencial Horizonte Verde',
                                 address: create(:address, public_place: 'Rua Principal', number: 100,
                                                           neighborhood: 'Centro', city: 'São Paulo',
                                                           state: 'SP', zip: '12345-678')
    second_condo = create :condo, name: 'Condomínio Bela Vista',
                                  address: create(:address, public_place: 'Avenida das Montanhas', number: 45,
                                                            neighborhood: 'Vila Nova', city: 'Rio de Janeiro',
                                                            state: 'RJ', zip: '45758-463')
    third_condo = create :condo, name: 'Vila do Sol Nascente',
                                 address: create(:address, public_place: 'Rua do Luar', number: 789,
                                                           neighborhood: 'Jardim do Sol', city: 'Belo Horizonte',
                                                           state: 'MG', zip: '14745-632')
    first_condo.managers << condo_manager
    third_condo.managers << condo_manager

    login_as condo_manager, scope: :manager
    visit root_path

    expect(page).not_to have_content second_condo.name
    expect(page).not_to have_content second_condo.address
    expect(page).to have_content first_condo.name
    expect(page).to have_content first_condo.address.public_place
    expect(page).to have_content third_condo.name
    expect(page).to have_content third_condo.address.public_place
  end

  it "and there's no condo registered" do
    manager = create :manager

    login_as manager, scope: :manager
    visit root_path

    expect(page).to have_content 'Não existem condomínios cadastrados no sistema.'
  end

  it "and sees condo's details" do
    manager = create :manager
    condo = create :condo, name: 'Residencial Horizonte Verde', registration_number: '87.570.020/0001-86',
                           address: create(:address, public_place: 'Rua Principal', number: 100,
                                                     neighborhood: 'Centro', city: 'São Paulo',
                                                     state: 'SP', zip: '12345-678')

    login_as manager, scope: :manager
    visit root_path
    click_on 'Residencial Horizonte Verde'

    expect(current_path).to eq condo_path condo
    expect(page).to have_content 'Residencial Horizonte Verde'
    expect(page).to have_content 'CNPJ: 87.570.020/0001-86'
    expect(page).to have_content 'Rua Principal, 100, Centro - São Paulo/SP - CEP: 12345-678'
  end

  it 'and there`s no link on side-bar when there´s no condo associated' do
    condo_manager = create :manager, is_super: false

    login_as condo_manager, scope: :manager
    visit root_path
    within 'nav' do
      click_on id: 'side-menu'
    end

    within 'nav' do
      expect(page).not_to have_link 'Criar Tipo de Unidade'
      expect(page).not_to have_link 'Criar Torre'
      expect(page).not_to have_link 'Criar Área Comum'
    end
  end
end
