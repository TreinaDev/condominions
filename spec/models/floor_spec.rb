require 'rails_helper'

RSpec.describe Floor, type: :model do
  describe '#generate_units' do
    it 'Generate units for this floor' do
      tower = build :tower, units_per_floor: 4
      floor = build(:floor, tower:)

      floor.generate_units

      expect(floor.units.count).to eq 4
    end
  end

  describe '#valid?' do
    it 'Tower must be present' do
      floor = build :floor, tower: nil

      expect(floor).not_to be_valid
      expect(floor.errors.full_messages).to include 'Torre é obrigatório(a)'
    end
  end
end
