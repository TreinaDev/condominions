require 'rails_helper'

describe 'User sees superintendent details' do
  context 'as manager' do
    it 'from condo details page' do
      condo = create :condo, name: 'Condomínio X'
      tower = create(:tower, condo:)
      unit11 = tower.floors.first.units.first
      resident = create :resident, full_name: 'Dona Alvara', residence: unit11, email: 'alvara@email.com'
      travel_to '2024-07-21'.to_date
      create(:superintendent, tenant: resident, condo:, start_date: '2024-07-21'.to_date,
                              end_date: '2024-07-25'.to_date)
      manager = create :manager

      resident.user_image.attach(io: Rails.root.join('spec/support/images/resident_photo.jpg').open,
                                 filename: 'resident_photo.jpg')

      login_as manager, scope: :manager
      visit condo_path condo
      click_on 'Dona Alvara'

      expect(page).to have_content 'Síndico do Condomínio X'
      expect(page).to have_css 'img[src*="resident_photo.jpg"]'
      within '#superintendent_data' do
        expect(page).to have_content 'Dona Alvara'
        expect(page).to have_content 'alvara@email.com'
        expect(page).to have_content 'Condomínio X'
        expect(page).to have_content 'Torre A'
        expect(page).to have_content 'Unidade: 11'
        expect(page).to have_content I18n.l('2024-07-21'.to_date)
        expect(page).to have_content I18n.l('2024-07-25'.to_date)
      end
      expect(page).to have_button 'Editar Síndico'
    end

    it 'and is not a condo manager' do
      condo = create :condo, name: 'Condomínio X'
      superintendent = create(:superintendent, condo:)
      manager = create :manager, is_super: false

      login_as manager, scope: :manager

      visit condo_superintendent_path(condo, superintendent)

      expect(current_path).to eq root_path
      expect(page).to have_content 'Você não tem permissão para fazer isso'
    end
  end

  context 'as resident' do
    it 'from condo details page' do
      condo = create :condo, name: 'Condomínio X'
      tower = create(:tower, condo:)
      unit11 = tower.floors.first.units.first
      resident = create :resident, full_name: 'Dona Alvara', residence: unit11, email: 'alvara@email.com'
      travel_to '2024-07-21'.to_date
      superintendent = create(:superintendent, tenant: resident, condo:, start_date: '2024-07-21'.to_date,
                                               end_date: '2024-07-25'.to_date)
      resident.user_image.attach(io: Rails.root.join('spec/support/images/resident_photo.jpg').open,
                                 filename: 'resident_photo.jpg')

      login_as resident, scope: :resident
      visit condo_path condo
      click_on 'Dona Alvara'

      expect(current_path).to eq condo_superintendent_path(condo, superintendent)
      expect(page).to have_content 'Síndico do Condomínio X'
      expect(page).to have_css 'img[src*="resident_photo.jpg"]'
      within '#superintendent_data' do
        expect(page).to have_content 'Dona Alvara'
        expect(page).to have_content 'alvara@email.com'
        expect(page).to have_content 'Condomínio X'
        expect(page).to have_content 'Torre A'
        expect(page).to have_content 'Unidade: 11'
        expect(page).to have_content I18n.l('2024-07-21'.to_date)
        expect(page).to have_content I18n.l('2024-07-25'.to_date)
      end

      expect(page).not_to have_button 'Editar Síndico'
    end

    it 'and is not a condo resident' do
      condo = create :condo, name: 'Condomínio X'
      superintendent = create(:superintendent, condo:)
      resident = create :resident

      login_as resident, scope: :resident

      visit condo_superintendent_path(condo, superintendent)

      expect(page).to have_content 'Você não tem permissão para fazer isso'
      expect(current_path).to eq root_path
    end
  end
end
