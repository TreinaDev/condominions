require 'rails_helper'

RSpec.describe Tower, type: :model do
  describe '#valid?' do
    it "Name can't be blank" do
      tower = build :tower, name: ''

      expect(tower).not_to be_valid
      expect(tower.errors.full_messages)
        .to include 'Nome não pode ficar em branco'
    end

    it "Floor quantity can't be blank" do
      tower = build :tower, floor_quantity: ''

      expect(tower).not_to be_valid
      expect(tower.errors.full_messages)
        .to include 'Quantidade de Andares não pode ficar em branco'
    end

    it "Units per floor can't be blank" do
      tower = build :tower, units_per_floor: ''

      expect(tower).not_to be_valid
      expect(tower.errors.full_messages)
        .to include 'Apartamentos por Andar não pode ficar em branco'
    end

    it 'Condo must be present' do
      tower = build :tower, condo: nil

      expect(tower).not_to be_valid
      expect(tower.errors.full_messages)
        .to include 'Condomínio é obrigatório(a)'
    end

    it 'Floor quantity must be a number' do
      tower = build :tower, floor_quantity: 'ten'

      expect(tower).not_to be_valid
      expect(tower.errors.full_messages)
        .to include 'Quantidade de Andares não é um número'
    end

    it 'Units per floor must be a number' do
      tower = build :tower, units_per_floor: 'five'

      expect(tower).not_to be_valid
      expect(tower.errors.full_messages)
        .to include 'Apartamentos por Andar não é um número'
    end

    it 'Floor quantity must be a positive number' do
      no_floor_tower = build :tower, floor_quantity: 0
      one_floor_tower = build :tower, floor_quantity: 1

      expect(no_floor_tower).not_to be_valid
      expect(one_floor_tower).to be_valid
      expect(no_floor_tower.errors.full_messages)
        .to include 'Quantidade de Andares deve ser maior que 0'
    end

    it 'Units per floor must be a positive number' do
      no_unit_tower = build :tower, units_per_floor: 0
      one_unit_tower = build :tower, units_per_floor: 1

      expect(no_unit_tower).not_to be_valid
      expect(one_unit_tower).to be_valid
      expect(no_unit_tower.errors.full_messages)
        .to include 'Apartamentos por Andar deve ser maior que 0'
    end
  end
end
