require 'rails_helper'

RSpec.describe Condo, type: :model do
  describe '#valid' do
    context 'presence' do
      it 'falso quando campos estiverem em branco' do
        condo = build(:condo, name: nil, registration_number: nil)

        expect(condo).not_to be_valid
        expect(condo.errors).to include(:name)
        expect(condo.errors).to include(:registration_number)
      end
    end

    context 'uniqueness' do
      it 'falso quando o CNPJ já estiver em uso' do
        create(:condo, registration_number: '38.352.640/0001-33')
        condo = build(:condo, registration_number: '38.352.640/0001-33')
        condo.valid?
        expect(condo.errors.full_messages).to include('CNPJ já está em uso')
      end
    end

    context 'validate_CNPJ' do
      it 'Verdadeiro quando o CNPJ é Válido' do
        condo = build(:condo, registration_number: '38.352.640/0001-33')
        condo.valid?
        expect(condo.errors.full_messages).not_to include('CNPJ inválido')
      end

      it 'Falso quando o CNPJ inválido' do
        condo = build(:condo, registration_number: '38352640000134')
        condo.valid?
        expect(condo.errors.full_messages).to include('CNPJ inválido')
      end
    end
  end

  describe '#full_address' do
    it 'Exibe o endereço completo' do
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
