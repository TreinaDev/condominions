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
end
