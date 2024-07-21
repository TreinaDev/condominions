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

  describe '#tax' do
    it 'returns the tax value from common area on external system' do
      common_area = build :common_area

      data = Rails.root.join('spec/support/json/common_areas/common_area_fee.json').read

      response = double('response', body: data, success?: true)

      allow(Faraday)
        .to receive(:get)
        .with("#{Rails.configuration.api['base_url']}/common_area_fees/#{common_area.id}")
        .and_return(response)

      expect(common_area.tax).to eq 4200
    end

    it 'returns error message if the request is not succeeded' do
      common_area = build :common_area

      data = Rails.root.join('spec/support/json/common_areas/common_area_fee_error.json').read

      allow(Faraday)
        .to receive(:get)
        .with("#{Rails.configuration.api['base_url']}/common_area_fees/#{common_area.id}")
        .and_return(double('response', body: data, success?: false))

      expect(common_area.tax).to eq 'Não identificada'
    end
  end
end
