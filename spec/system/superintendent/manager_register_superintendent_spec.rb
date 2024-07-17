require 'rails_helper'

describe 'Manager register superintendent' do
    it 'Successfully' do
        condo = create :condo, name: 'Condomínio X'
        tower = create(:tower, condo:)
        floor = create(:floor, tower:)
        unit11 = floor.units.first
        manager = create :manager
        resident = create :resident, full_name: 'Alvus Dumbledore'
        
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

        expect(current_path).to eq new_condo_superintendent_path condo
        expect(page).to have_content 'Registrar Mandato de Síndico para Condomínio X'
        fill_in 'Data de ínicio', with: Date.today
        fill_in 'Data de conclusão', with: 1.year.from_now
        select 'Alvus Dumbledore', from: 'Morador'
        click_on 'Cadastrar Gestão'
    end
end