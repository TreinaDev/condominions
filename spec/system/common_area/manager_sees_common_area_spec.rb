require 'rails_helper'

describe 'Administrator sees common area details' do
  it 'only if authenticated' do
    common_area = create :common_area

    visit common_area_path common_area

    expect(current_path).to eq signup_choice_path
  end

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
    expect(page).to have_content 'Descrição: Churrasco comunitário'
    expect(page).to have_content 'Capacidade Máxima: 50 pessoas'
    expect(page).to have_content 'Regras de Uso: Proibido fumar'
  end

  it 'and the resident can see a common area details page too' do
    resident = create :resident
    common_area = create :common_area

    login_as resident, scope: :resident
    visit common_area_path common_area

    expect(current_path).to eq common_area_path common_area
  end
end
