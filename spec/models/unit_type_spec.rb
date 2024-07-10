require 'rails_helper'

RSpec.describe UnitType, type: :model do
  context '#update_fractions' do
    it 'All added together should give 100' do
      condo = create(:condo)
      unit_type1 = create(:unit_type, description: 'Apartamento de 1 quarto', condo:, metreage: 50)
      unit_type2 = create(:unit_type, description: 'Apartamento de 2 quartos', condo:, metreage: 100)

      tower1 = create(:tower, floor_quantity: 5, condo:, units_per_floor: 2)
      tower1.generate_floors
      tower1.floors.each do |floor|
        floor.units[0].update unit_type: unit_type1
        floor.units[1].update unit_type: unit_type2
      end
      UnitType.update_fractions(tower1.condo)
      unit_type1.reload
      unit_type2.reload

      sum = (unit_type1.fraction * unit_type1.units.count) + (unit_type2.fraction * unit_type2.units.count)
      expect(sum).to eq 100
    end

    it 'update fractions for all unit types' do
      condo = create(:condo)
      unit_type1 = create(:unit_type, description: 'Apartamento de 1 quarto', condo:, metreage: 50)
      unit_type2 = create(:unit_type, description: 'Apartamento de 2 quartos', condo:, metreage: 100)

      tower1 = create(:tower, floor_quantity: 5, condo:, units_per_floor: 2)
      tower1.generate_floors
      tower1.floors.each do |floor|
        floor.units[0].update unit_type: unit_type1
        floor.units[1].update unit_type: unit_type1
      end
      UnitType.update_fractions(tower1.condo)
      unit_type1.reload
      fraction1 = unit_type1.fraction

      tower2 = create(:tower, floor_quantity: 5, condo:, units_per_floor: 2)
      tower2.generate_floors
      tower2.floors.each do |floor|
        floor.units[0].update unit_type: unit_type2
        floor.units[1].update unit_type: unit_type2
      end
      UnitType.update_fractions(tower1.condo)
      unit_type1.reload
      fraction2 = unit_type1.fraction

      expect(fraction1).not_to eq fraction2
    end
  end

  context '#unit_ids' do
    it "return ids from unit type's units" do
      unit_type = build :unit_type
      unit = create(:unit, unit_type:)

      expect(unit_type.unit_ids).to include unit.id
    end
  end

  context '#valid?' do
    it 'missing params' do
      unit_type = UnitType.new(description: '', metreage: '')

      expect(unit_type).not_to be_valid
      expect(unit_type.errors).to include(:description)
      expect(unit_type.errors).to include(:metreage)
    end

    context 'Metreage must be bigger than zero' do
      it 'metreage equal zero' do
        unit_type = UnitType.new(metreage: 0)

        expect(unit_type).not_to be_valid
        expect(unit_type.errors.full_messages).to include('Metragem deve ser maior que 0')
      end
      it 'metreage less than zero' do
        unit_type = UnitType.new(metreage: -1)

        expect(unit_type).not_to be_valid
        expect(unit_type.errors.full_messages).to include('Metragem deve ser maior que 0')
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
