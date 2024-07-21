require 'rails_helper'

describe 'User access common area details' do
  it 'only if authenticated' do
    common_area = create :common_area

    visit common_area_path common_area

    expect(current_path).to eq signup_choice_path
  end

  context 'as a manager' do
    it 'from the condo details page' do
      condo = create :condo
      condo_manager = create :manager, is_super: false
      common_area = create :common_area,
                           condo:,
                           name: 'Churrasqueira',
                           description: 'Churrasco comunitário',
                           max_occupancy: 50,
                           rules: 'Proibido fumar'

      condo.managers << condo_manager

      login_as condo_manager, scope: :manager
      visit condo_path condo
      click_on 'Lista de Áreas Comuns'
      find('#common-area-1').click

      expect(current_path).to eq common_area_path common_area
      expect(page).to have_content 'Churrasqueira'
      expect(page).to have_content 'Churrasco comunitário'
      expect(page).to have_content 'Capacidade Máxima: 50 pessoas'
      expect(page).to have_content 'Regras de Uso'
      expect(page).to have_content 'Proibido fumar'
    end
  end

  context 'as a resident' do
    it "only if has a residence at common area's condo" do
      first_condo = create :condo
      first_resident = create :resident, :with_residence, condo: first_condo

      second_condo = create :condo
      common_area = create :common_area, condo: second_condo

      login_as first_resident, scope: :resident
      visit common_area_path common_area

      expect(current_path).to eq root_path
      expect(page).to have_content 'Você não tem permissão para fazer isso'
    end

    it 'successfully' do
      common_area = create :common_area
      resident = create :resident, :with_residence, condo: common_area.condo

      login_as resident, scope: :resident
      visit common_area_path common_area

      expect(current_path).to eq common_area_path common_area
    end
  end
end
