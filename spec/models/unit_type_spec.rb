require 'rails_helper'

RSpec.describe UnitType, type: :model do
  context '#valid?' do
    it 'missing params' do
      unit_type = UnitType.new(description: '', metreage: '')

      expect(unit_type).not_to be_valid
      expect(unit_type.errors.include?(:description)).to be true
      expect(unit_type.errors.include?(:metreage)).to be true
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
end
