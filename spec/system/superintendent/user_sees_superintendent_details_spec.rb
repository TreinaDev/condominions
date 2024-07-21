require 'rails_helper'

describe 'User sees superintendent details' do
  context 'as manager' do
    it 'from condo details page' do
      condo = create :condo, name: 'Condomínio X'
      tower = create(:tower, condo:)
      unit11 = tower.floors.first.units.first
      resident = create :resident, full_name: 'Dona Alvara', residence: unit11, email: 'alvara@email.com'
      create(:superintendent, condo:, tenant: resident, start_date: Time.zone.today,
                              end_date: Time.zone.today >> 2)
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
        expect(page).to have_content I18n.l Time.zone.today
        expect(page).to have_content I18n.l(Time.zone.today >> 2)
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
      superintendent = create(:superintendent, condo:, tenant: resident, start_date: Time.zone.today,
                                               end_date: Time.zone.today >> 2)
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
        expect(page).to have_content I18n.l Time.zone.today
        expect(page).to have_content I18n.l(Time.zone.today >> 2)
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
