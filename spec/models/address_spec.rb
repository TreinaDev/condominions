require 'rails_helper'

RSpec.describe Address, type: :model do
  describe '#valid' do
    context 'presence' do
      it 'falso quando campos estiverem vazios' do
        address = build(:address, public_place: nil, number: nil, neighborhood: nil,
                                  city: nil, state: nil, zip: nil)

        expect(address).not_to be_valid
        expect(address.errors).to include(:public_place)
        expect(address.errors).to include(:number)
        expect(address.errors).to include(:neighborhood)
        expect(address.errors).to include(:city)
        expect(address.errors).to include(:state)
        expect(address.errors).to include(:zip)
      end
    end

    context 'numericality' do
      it 'falso quando o CEP não for formado apenas por números' do
        address = build(:address, zip: 'K000')
        address.valid?
        expect(address.errors.full_messages).to include('CEP não é um número')
      end

      it 'falso quando o CEP for menor do que 0' do
        address = build(:address, zip: '-95')
        address.valid?
        expect(address.errors.full_messages).to include('CEP deve ser maior que 0')
      end
    end

    context 'length' do
      it 'falso quando o CEP não tiver 8 números' do
        address = build(:address, zip: 123)
        address.valid?
        expect(address.errors.full_messages).to include('CEP não possui o tamanho esperado (8 caracteres)')
      end
    end
  end
end
