require 'rails_helper'

RSpec.describe Address, type: :model do
  describe '#valid' do
    context 'presence' do
      it 'false when params are empty' do
        address = build(:address, public_place: nil, number: nil, neighborhood: nil,
                                  city: nil, state: nil, zip: nil)

        expect(address).not_to be_valid
        expect(address.errors).to include(:public_place)
        expect(address.errors).to include(:number)
        expect(address.errors).to include(:neighborhood)
        expect(address.errors).to include(:city)
        expect(address.errors).to include(:state)
      end
    end

    context 'ZIP format' do
      it 'valid: XXXXX-XXX' do
        address = build(:address, zip: '49042-300')

        expect(address).to be_valid
      end

      it 'not valid' do
        address = build(:address, zip: '49042300')

        expect(address).not_to be_valid
        expect(address.errors.full_messages).to include('CEP deve estar no seguinte formato: XXXXX-XXX')
      end
    end
  end
end
