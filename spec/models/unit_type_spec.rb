require 'rails_helper'

RSpec.describe UnitType, type: :model do
  context '#valid?' do
    it 'missing params' do
      unit_type = UnitType.new(description: '', metreage: '', fraction: '')

      expect(unit_type).not_to be_valid
      expect(unit_type.errors).to include(:description)
      expect(unit_type.errors).to include(:metreage)
      expect(unit_type.errors).to include(:fraction)
    end

    context 'Metreage must be bigger than zero' do
      it 'metreage equal zero' do
        unit_type = UnitType.new(metreage: 0)

        expect(unit_type).not_to be_valid
        expect(unit_type.errors).to include(:metreage)
      end
      it 'metreage less than zero' do
        unit_type = UnitType.new(metreage: -1)

        expect(unit_type).not_to be_valid
        expect(unit_type.errors).to include(:metreage)
      end
    end

    context 'Fraction must be bigger than zero' do
      it 'fraction equal zero' do
        unit_type = UnitType.new(fraction: 0)

        expect(unit_type).not_to be_valid
        expect(unit_type.errors).to include(:fraction)
      end
      it 'fraction less than zero' do
        unit_type = UnitType.new(fraction: -1)

        expect(unit_type).not_to be_valid
        expect(unit_type.errors).to include(:fraction)
      end
    end
  end

  context 'formatted text' do
    it 'show metreage value with square meter (m²)' do
      unit_type = create(:unit_type, metreage: 12.45)
      styled_text = unit_type.metreage_to_square_meters

      expect(styled_text).to eq('12.45m²')
    end

    it 'show fraction value with percentage symbol (%)' do
      unit_type = create(:unit_type, fraction: 10.12345)
      styled_text = unit_type.fraction_to_percentage

      expect(styled_text).to eq('10.12345%')
    end
  end
end
