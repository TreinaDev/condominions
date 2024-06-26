require 'rails_helper'

RSpec.describe Address, type: :model do
  describe '#valid' do 
    context "presence" do
      it 'falso quando o logradouro estiver vazio' do 
        address = build(:address, public_place: nil)
        address.valid?
        expect(address.errors.full_messages).to include('Logradouro não pode ficar em branco')
      end

      it 'falso quando o número estiver vazio' do
        address = build(:address, number: nil)
        address.valid?
        expect(address.errors.full_messages).to include('N° não pode ficar em branco')
      end

      it 'falso quando o bairro estiver vazio' do
        address = build(:address, neighborhood: nil)
        address.valid?
        expect(address.errors.full_messages).to include('Bairro não pode ficar em branco')
      end

      it 'falso quando o cidade estiver vazio' do
        address = build(:address, city: nil)
        address.valid?
        expect(address.errors.full_messages).to include('Cidade não pode ficar em branco')
      end

      it 'falso quando o estado estiver vazio' do
        address = build(:address, state: nil)
        address.valid?
        expect(address.errors.full_messages).to include('Estado não pode ficar em branco')
      end

      it 'falso quando o CEP estiver vazio' do
        address = build(:address, zip: nil)
        address.valid?
        expect(address.errors.full_messages).to include('CEP não pode ficar em branco')
      end
    end

    context 'numericality' do
      it "falso quando o CEP não for formado apenas por números" do
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
      it "falso quando o CEP não tiver 8 números" do
        address = build(:address, zip: 123)
        address.valid?
        expect(address.errors.full_messages).to include('CEP não possui o tamanho esperado (8 caracteres)')
      end
    end
  end
end
