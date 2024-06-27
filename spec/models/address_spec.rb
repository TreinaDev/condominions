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
      end
    end
  end
end
