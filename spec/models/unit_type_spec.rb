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
  end
end
