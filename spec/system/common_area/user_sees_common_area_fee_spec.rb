require 'rails_helper'

describe 'User sees common area fee' do
  context 'as a resident' do
    it 'successfully' do
      condo = create :condo
      resident = create(:resident, :with_residence, condo:)
      common_area = create :common_area, condo:, id: 2

      data = Rails.root.join('spec/support/json/common_areas/common_area_fees.json').read

      allow(Faraday)
        .to receive(:get)
        .with("#{Rails.configuration.api['base_url']}/condos/#{common_area.condo.id}/common_area_fees")
        .and_return(double('response', body: data, success?: true))

      login_as resident, scope: :resident
      visit common_area_path common_area

      expect(page).to have_content 'Taxa da reserva: R$300,00'
    end

    it 'and see a message if the fee is not found' do
      condo = create :condo
      resident = create(:resident, :with_residence, condo:)
      common_area = create :common_area, condo:, id: 99

      data = Rails.root.join('spec/support/json/common_areas/common_area_fees.json').read

      allow(Faraday)
        .to receive(:get)
        .with("#{Rails.configuration.api['base_url']}/condos/#{common_area.condo.id}/common_area_fees")
        .and_return(double('response', body: data, success?: true))

      login_as resident, scope: :resident
      visit common_area_path common_area

      expect(page).to have_content 'Taxa da reserva: Não informada'
    end
  end

  context 'as a manager' do
    it 'successfully' do
      manager = create :manager
      common_area = create :common_area, id: 2

      data = Rails.root.join('spec/support/json/common_areas/common_area_fees.json').read

      allow(Faraday)
        .to receive(:get)
        .with("#{Rails.configuration.api['base_url']}/condos/#{common_area.condo.id}/common_area_fees")
        .and_return(double('response', body: data, success?: true))

      login_as manager, scope: :manager
      visit common_area_path common_area

      expect(page).to have_content 'Taxa da reserva: R$300,00'
    end
  end
end
