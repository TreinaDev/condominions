require 'rails_helper'

RSpec.describe Tower, type: :model do
  describe '#generate_floors' do
    it 'Generate floors for this tower' do
      tower = build :tower, floor_quantity: 3

      tower.generate_floors

      expect(tower.floors.count).to eq 3
    end
  end

  describe '#valid?' do
    it 'Missing params' do
      tower = build :tower, name: '',
                            floor_quantity: '',
                            units_per_floor: '',
                            condo: nil

      expect(tower).not_to be_valid
      expect(tower.errors.include?(:name)).to be true
      expect(tower.errors.include?(:floor_quantity)).to be true
      expect(tower.errors.include?(:units_per_floor)).to be true
      expect(tower.errors.include?(:condo)).to be true
    end

    it 'Floor Quantity and Units per Floor must be numbers' do
      tower = build :tower, floor_quantity: 'ten', units_per_floor: 'five'

      expect(tower).not_to be_valid
      expect(tower.errors.include?(:floor_quantity)).to be true
      expect(tower.errors.include?(:units_per_floor)).to be true
      expect(tower.errors.full_messages)
        .to include 'Quantidade de Andares não é um número'
      expect(tower.errors.full_messages)
        .to include 'Apartamentos por Andar não é um número'
    end

    it 'Floor quantity must be greater than 0' do
      no_floor_tower = build :tower, floor_quantity: 0, units_per_floor: 0
      one_floor_tower = build :tower, floor_quantity: 1, units_per_floor: 1

      expect(no_floor_tower).not_to be_valid
      expect(one_floor_tower).to be_valid
      expect(no_floor_tower.errors.full_messages)
        .to include 'Quantidade de Andares deve ser maior que 0'
    end

    it 'Units per floor must greater than 0' do
      no_unit_tower = build :tower, units_per_floor: 0
      one_unit_tower = build :tower, units_per_floor: 1

      expect(no_unit_tower).not_to be_valid
      expect(one_unit_tower).to be_valid
      expect(no_unit_tower.errors.full_messages)
        .to include 'Apartamentos por Andar deve ser maior que 0'
    end
  end
end
