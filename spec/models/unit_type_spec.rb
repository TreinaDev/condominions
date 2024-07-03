require 'rails_helper'

RSpec.describe UnitType, type: :model do
  context '#valid?' do
    it 'missing params' do
      unit_type = UnitType.new(description: '', metreage: '', fraction: '')

      expect(unit_type).not_to be_valid
      expect(unit_type.errors.include?(:description)).to be true
      expect(unit_type.errors.include?(:metreage)).to be true
      expect(unit_type.errors.include?(:fraction)).to be true
    end

    context 'Metreage must be bigger than zero' do
      it 'metreage equal zero' do
        unit_type = UnitType.new(metreage: 0)
        unit_type.valid?

        expect(unit_type.errors.include?(:metreage)).to be true
      end
      it 'metreage less than zero' do
        unit_type = UnitType.new(metreage: -1)
        unit_type.valid?

        expect(unit_type.errors.include?(:metreage)).to be true
      end
    end
  end

  context 'formatted text' do
    it 'show metreage value with square meter (m²)' do
      unit_type = create(:unit_type, metreage: 12.45)
      styled_text = unit_type.metreage_to_square_meters

      expect(styled_text).to eq('12.45m²')
    end

    it 'show metreage value with square meter (m²)' do
      unit_type = create(:unit_type, fraction: 10.12345)
      styled_text = unit_type.fraction_to_percentage

      expect(styled_text).to eq('10.12345%')
    end
  end
end
