require 'rails_helper'

RSpec.describe UnitType, type: :model do
  context 'Unit Type#' do
    it 'missing description' do
      unit_type = UnitType.new(description: '')
      unit_type.valid?

      expect(unit_type.errors.include?(:description)).to be true
    end

    it 'missing metreage' do
      unit_type = UnitType.new(metreage: '')
      unit_type.valid?

      expect(unit_type.errors.include?(:metreage)).to be true
    end

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
