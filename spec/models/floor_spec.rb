require 'rails_helper'

RSpec.describe Floor, type: :model do
  describe '#generate_units' do
    it 'Generate units for this floor' do
      tower = create :tower, units_per_floor: 4
      floor = tower.floors[0]

      expect(floor.units.count).to eq 4
    end
  end

  describe '#identifier' do
    it 'returns identifier' do
      tower = create :tower, units_per_floor: 4

      expect(tower.floors[2].identifier).to eq 3
    end
  end

  describe '#print_identifier' do
    it 'returns identifier description' do
      tower = create :tower, units_per_floor: 4

      expect(tower.floors[2].print_identifier).to eq '3º Andar'
    end
  end

  describe '#return_unit_types' do
    it "it returns unit types from floor's units" do
      first_unit_type =  create :unit_type, description: 'Apartamento de 1 quarto', metreage: 50.55
      second_unit_type = create :unit_type, description: 'Apartamento de 2 quartos', metreage: 80.75
      tower = create :tower, units_per_floor: 5, floor_quantity: 3
      floor = tower.floors[1]

      floor.units[0].update unit_type: second_unit_type
      floor.units[1].update unit_type: first_unit_type
      floor.units[2].update unit_type: second_unit_type
      floor.units[3].update unit_type: first_unit_type
      floor.units[4].update unit_type: second_unit_type

      unit_types = [first_unit_type, second_unit_type]

      expect(floor.return_unit_types).to eq unit_types
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
