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
  end
end
