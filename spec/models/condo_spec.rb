require 'rails_helper'

RSpec.describe Condo, type: :model do
  describe '#set_units_type_fractions' do
    context 'after define units types in condo tower floors' do
      it 'calculate sucessfully' do
        condo = create(:condo)
        first_unit_type = create :unit_type,
                                 description: 'Apartamento de 1 quarto',
                                 condo:,
                                 metreage: 50,
                                 fraction: nil
        second_unit_type = create :unit_type,
                                  description: 'Apartamento de 2 quartos',
                                  condo:,
                                  metreage: 150,
                                  fraction: nil
        tower = create :tower,
                       floor_quantity: 5,
                       condo:,
                       units_per_floor: 2

        tower.floors.each do |floor|
          floor.units[0].update unit_type: first_unit_type
          floor.units[1].update unit_type: second_unit_type
        end
        condo.set_unit_types_fractions

        expect(first_unit_type.reload.fraction).to eq(5)
        expect(second_unit_type.reload.fraction).to eq(15)
      end
    end
  end

  describe '#valid' do
    context 'presence' do
      it 'false when params are empty' do
        condo = build(:condo, name: nil, registration_number: nil)

        expect(condo).not_to be_valid
        expect(condo.errors).to include(:name)
        expect(condo.errors).to include(:registration_number)
      end
    end

    context 'uniqueness' do
      it 'false when registration number is already in use' do
        create(:condo, registration_number: '38.352.640/0001-33')
        condo = build(:condo, registration_number: '38.352.640/0001-33')
        condo.valid?
        expect(condo.errors.full_messages).to include('CNPJ já está em uso')
      end
    end

    context 'validate_CNPJ' do
      it 'is valid' do
        condo = build(:condo, registration_number: '38.352.640/0001-33')
        condo.valid?
        expect(condo.errors.full_messages).not_to include('CNPJ inválido')
      end

      it 'not valid' do
        condo = build(:condo, registration_number: '88.99.555/4444-44')
        condo.valid?
        expect(condo.errors.full_messages).to include('CNPJ inválido')
      end
    end

    context 'Regitration number format' do
      it 'valid: XX.XXX.XXX/XXXX-XX' do
        condo = build(:condo, registration_number: '38.352.640/0001-33')

        expect(condo).to be_valid
      end

      it 'not valid' do
        condo = build(:condo, registration_number: '38352640000133')

        expect(condo).not_to be_valid
        expect(condo.errors.full_messages).to include('CNPJ deve estar no seguinte formato: XX.XXX.XXX/XXXX-XX')
      end
    end
  end

  describe '#full_address' do
    it 'show full address' do
      address = build(:address, public_place: 'Travessa João Edimar',
                                number: '29', neighborhood: 'João Eduardo II',
                                city: 'Rio Branco', state: 'AC', zip: '69911-520')
      condo = create(:condo, 'address' => address)
      result = condo.full_address
      expect = 'Travessa João Edimar, 29, João Eduardo II - Rio Branco/AC - CEP: 69911-520'
      expect(result).to eq expect
    end
  end
end
