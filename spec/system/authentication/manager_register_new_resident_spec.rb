require 'rails_helper'

describe 'Manager registers new resident' do
  it 'from the menu' do
    manager = create(:manager)
    create(:condo, name: 'Condominio Errado')
    condo = create(:condo, name: 'Condominio Certo')
    create(:tower, 'condo' => condo, name: 'Torre errada')
    create(:tower, 'condo' => condo, name: 'Torre correta', floor_quantity: 10, units_per_floor: 5)

    login_as(manager, scope: :manager)
    visit root_path
    within('nav') do
      click_on id: 'side-menu'
      click_on 'Gerenciar usuarios'
      click_on 'Cadastrar morador'
    end

    fill_in 'Nome Completo', with: 'Adroaldo Junior'
    fill_in 'CPF',	with: CPF.generate(format: true)
    fill_in 'E-mail',	with: 'adroaldo@email.com'
    fill_in 'Senha', with: 'senha123'
    select 'Proprietário', from: 'Tipo de Morador'
    select 'Condominio Certo', from: 'Condomínio'
    select 'Torre correta', from: 'Torre'
    select '5', from: 'Andar'
    select '3', from: 'Unidade'
    click_on 'Enviar'

    expect(page).to have_content 'Convite enviado com sucesso para Adroaldo Junior (adroaldo@email.com)'
    expect(Resident.last.full_name).to eq 'Adroaldo Junior'
    expect(Resident.last.status).to eq 'not_confirmed'
  end
end
