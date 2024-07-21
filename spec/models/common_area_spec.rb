require 'rails_helper'

RSpec.describe CommonArea, type: :model do
  describe '#valid?' do
    it 'missing params' do
      common_area = CommonArea.new(name: '', description: '', max_occupancy: '')

      common_area.valid?
      expect(common_area.errors).to include(:name)
      expect(common_area.errors).to include(:description)
      expect(common_area.errors).to include(:max_occupancy)
    end

    it 'max occupancy should not be 0' do
      common_area = build(:common_area, max_occupancy: 0)

      common_area.valid?
      expect(common_area.errors).to include(:max_occupancy)
    end

    it 'max occupancy should not be negative' do
      common_area = build(:common_area, max_occupancy: -3)

      common_area.valid?
      expect(common_area.errors).to include(:max_occupancy)
    end

    it 'max occupancy must be positive' do
      common_area = build(:common_area, max_occupancy: 10)

      common_area.valid?
      expect(common_area.errors).not_to include(:max_occupancy)
    end
  end

  describe '#formatted_fee' do
    it 'returns the fee value from common area on external system' do
      common_area = build :common_area, id: 2

      data = Rails.root.join('spec/support/json/common_areas/common_area_fees.json').read

      allow(Faraday)
        .to receive(:get)
        .with("#{Rails.configuration.api['base_url']}/condos/#{common_area.condo.id}/common_area_fees")
        .and_return(double('response', body: data, success?: true))

      expect(common_area.formatted_fee).to eq 'R$300,00'
    end

    it 'returns a message if the fee is not found' do
      common_area = build :common_area, id: 99

      data = Rails.root.join('spec/support/json/common_areas/common_area_fees.json').read

      allow(Faraday)
        .to receive(:get)
        .with("#{Rails.configuration.api['base_url']}/condos/#{common_area.condo.id}/common_area_fees")
        .and_return(double('response', body: data, success?: true))

      expect(common_area.formatted_fee).to eq 'Não informada'
    end
  end
end
