require 'rails_helper'

RSpec.describe Tower, type: :model do
  describe '#valid?' do
    it 'false when name is blank' do
      tower = Tower.new name: ''

      tower.valid?

      expect(tower.errors.full_messages
        .include? 'Nome não pode ficar em branco').to be true
    end

    it 'false when floor quantity is blank' do
      tower = Tower.new floor_quantity: ''

      tower.valid?

      expect(tower.errors.full_messages
        .include? 'Quantidade de Andares não pode ficar em branco').to be true
    end

    it 'false when units per floor is blank' do
      tower = Tower.new units_per_floor: ''

      tower.valid?

      expect(tower.errors.full_messages
        .include? 'Apartamentos por Andar não pode ficar em branco').to be true
    end

    it 'false when condo is missing' do
      tower = Tower.new

      tower.valid?

      expect(tower.errors.full_messages
        .include? 'Condomínio é obrigatório(a)').to be true
    end

    it "false when floor quantity isn't a number" do
      tower = Tower.new floor_quantity: 'ten'

      tower.valid?

      expect(tower.errors.full_messages
        .include? 'Quantidade de Andares não é um número').to be true
    end

    it "false when units per floor isn't a number" do
      tower = Tower.new units_per_floor: 'five'

      tower.valid?

      expect(tower.errors.full_messages
        .include? 'Apartamentos por Andar não é um número').to be true
    end

    it "true when floor quantity is a positive number" do
      tower = Tower.new floor_quantity: 0

      tower.valid?

      expect(tower.errors.full_messages
        .include? 'Quantidade de Andares deve ser maior ou igual a 0').to be false
    end

    it "false when floor quantity isn't a positive number" do
      tower = Tower.new floor_quantity: -1

      tower.valid?

      expect(tower.errors.full_messages
        .include? 'Quantidade de Andares deve ser maior ou igual a 0').to be true
    end

    it "true when units per floor is a positive number" do
      tower = Tower.new units_per_floor: 0

      tower.valid?

      expect(tower.errors.full_messages
        .include? 'Apartamentos por Andar deve ser maior ou igual a 0').to be false
    end

    it "false when units per floor isn't a positive number" do
      tower = Tower.new units_per_floor: -1

      tower.valid?

      expect(tower.errors.full_messages
        .include? 'Apartamentos por Andar deve ser maior ou igual a 0').to be true
    end
  end
end
