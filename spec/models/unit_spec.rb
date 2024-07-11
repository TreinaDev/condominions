require 'rails_helper'

RSpec.describe Unit, type: :model do
  describe '#print_identifier' do
    it 'returns identifier description' do
      tower = create :tower, units_per_floor: 5, floor_quantity: 3
      floor = tower.floors[1]
      unit = floor.units.first

      expect(unit.print_identifier).to eq 'Unidade 21'
    end
  end
end
